Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36362 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbcHJWZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 18:25:49 -0400
Date: Wed, 10 Aug 2016 22:25:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>, Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs dev del hangs on 4.7
Message-ID: <20160810222547.GG9644@carfax.org.uk>
References: <20160809172758.GB9644@carfax.org.uk>
 <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
 <20160809182356.GC9644@carfax.org.uk>
 <b325a93d-47ca-be69-04b2-271cd7387506@fb.com>
 <20160809182733.GD9644@carfax.org.uk>
 <20160809191134.GE9644@carfax.org.uk>
 <4d0c6117-da81-b13f-667a-d36dcae7e979@fb.com>
 <20160809194142.GF9644@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
In-Reply-To: <20160809194142.GF9644@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 09, 2016 at 07:41:42PM +0000, Hugo Mills wrote:
> On Tue, Aug 09, 2016 at 03:22:03PM -0400, Chris Mason wrote:
> > 
> > 
> > On 08/09/2016 03:11 PM, Hugo Mills wrote:
> > >On Tue, Aug 09, 2016 at 06:27:33PM +0000, Hugo Mills wrote:
> > >>On Tue, Aug 09, 2016 at 02:26:14PM -0400, Chris Mason wrote:
> > >>>On 08/09/2016 02:23 PM, Hugo Mills wrote:
> > >>>>  Hi, Chris,
> > >>>>
> > >>>>On Tue, Aug 09, 2016 at 02:02:20PM -0400, Chris Mason wrote:
> > >>>>>On 08/09/2016 01:27 PM, Hugo Mills wrote:
> > >>>>>> Over the weekend, I started doing some maintenance on my server: I
> > >>>>>>upgraded to 4.7.0, and I started deleting a device from my array,
> > >>>>>>preparatory to putting in a larger one. About halfway through the
> > >>>>>>operation, several kernel threads hung up for a while (resulting in
> > >>>>>>"blocked for 120s" messages), and then the delete process seems to
> > >>>>>>have stopped entirely, although several kernel threads are at maximum
> > >>>>>>usage.
> > >>>>>>
> > >>>>>> After a few hours, I rebooted the machine, and left it for a day or
> > >>>>>>so. I tried the delete again this afternoon, and it's done the same
> > >>>>>>thing again. The full log is included below. I have a kworker and a
> > >>>>>>btrfs-transaction pegged at close to 100% of a core each, and a
> > >>>>>>btrfs-cleaner (and the btrfs dev del process) in D state.
> > >>>>>>
> > >>>>>> The FS was not under load at the time of the failure, and it passes
> > >>>>>>scrub. I haven't tried a btrfs check yet.
> > >>>>>
> > >>>>>Thanks Hugo, can you nail down which line of code belongs to:
> > >>>>>
> > >>>>>btrfs_async_run_delayed_refs+0xc6
> > >>>>
> > >>>>  I'm having a spot of trouble with this. The btrfs on this kernel is
> > >>>>built-in, and I've lost the contents of the build directory (it's done
> > >>>>by an overnight build script, and it's already built a 4.8-rc1 for one
> > >>>>of my other machines).
> > >>>>
> > >>>>(gdb) file /boot/vmlinuz-4.7.0-dirty
> > >>>>BFD: /boot/vmlinuz-4.7.0-dirty: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
> > >>>>Reading symbols from /boot/vmlinuz-4.7.0-dirty...(no debugging symbols found)...done.
> > >>>>(gdb) list *btrfs_async_run_delayed_refs+0xc6
> > >>>>No symbol table is loaded.  Use the "file" command.
> > >>>>
> > >>>>  There must be a way of getting this info from here, but I'm not
> > >>>>sure I know what it is. Build a new kernel from 4.7 with this
> > >>>>machine's config and run gdb on the btrfs.o file? Not a problem to do,
> > >>>>but it might take a little while.
> > >>>
> > >>>As long as you use the same gcc and config file, it'll almost always
> > >>>generate the same offsets/code.  You can recompile with debug
> > >>>symbols on and it'll be accurate.
> > >>
> > >>   OK. Back later.
> > >
> > >(gdb) file fs/btrfs/btrfs.o
> > >Reading symbols from fs/btrfs/btrfs.o...done.
> > >(gdb) list *btrfs_async_run_delayed_refs+0xc6
> > >0x13dae is in btrfs_async_run_delayed_refs (fs/btrfs/extent-tree.c:2915).
> > >2910	
> > >2911		btrfs_queue_work(root->fs_info->extent_workers, &async->work);
> > >2912		
> > >2913			if (wait) {
> > >2914			   	  wait_for_completion(&async->wait);
> > >2915						ret = async->error;
> > >2916						      kfree(async);
> > >2917								return ret;
> > >2918								       }
> > >2919									return 0;
> > 
> > So its waiting on the actual delayed ref work but we don't see them
> > in the stack trace.
> > 
> > Can you please sysrq-w and sysrq-t?
> 
>    Not right now -- I wanted to watch a film, and rebooted the machine
> to get NFS working again. It's now refusing to boot. I think that's
> unrelated to this issue (different filesystems are involved for a
> start), but it's stopping me from doing anything else. :(
> 
>    I'll reproduce the failure, and get back to you with the sysrq
> dumps tomorrow.

   I restarted the device delete this evening, and it's not thrown the
error again. I'll be doing some more device reorganisation over the
next week or two, so it may happen again, but for now, I think we'll
have to write this report off as an undiagnosed transient error.

   Hugo.

-- 
Hugo Mills             | I thought I'd discovered a new colour, but it was
hugo@... carfax.org.uk | just a pigment of my imagination.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXq6nqAAoJEFheFHXiqx3kfk0P/j3h02h7+rmYrhIx5L6AOQXD
8Xzx+jkM8kGgjHWtNfsxOa+qSBi9fyA9NvbfWSITDsOXlaAaPgPFsswH25tmCjjV
mRDzXCU42uKaB4KgDOqwh3Ms60TthgoGqARhjPaV4eJuKYMyg5t22rplfwotJd1d
eA7GyQmHjCXlVe4RT8vkCVO8Y0UPnG0PP6VJHVvj0PaEFQMtwmT8RsF1SD3VC0lK
29b8CXKWis/UQjCFAcrPPCdStKQdNK8GTbVJnMaLvz8zYwpxPQO1ZRVyxKM0Znxg
IijUHgx4BMfETlbSrzeeRHfvMxWWMXdKEkzRJCpjvKRNxdBLagjMtJ9uI9lZL4d4
oM1XEGkp83x1uQC5ieCTIGzqTmiGaOpXqUWpLEq2z5enRg9tIgfn/rp3ROUFGnSm
fiXI/qFB7tB/W8LWmUvXetwgkdavuHpekw4OfXB21zWesKQQEji93Fbba9kWLJk/
EKG1B61GrG/2XmsjeICpyUfXl+GUstmzri44BpaAQZS9gOp465rvNpS+XOsn4L31
VCweS7Q3vLq6iZZAh7BEMYuZN9C8VXR288i9DG+BUGyl/y88UQnNAbVk5Z+XmtM0
Td/WoqZFSBMrMKNHGJsMUdk87Zwz6LjnBIZRsq5XhzDXdDIwLc401qvKOR5oXKlv
ToSUPltN3OuFN6dFy2XE
=NnuA
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
