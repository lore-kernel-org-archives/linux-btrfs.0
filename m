Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60974 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbcHITlo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 15:41:44 -0400
Date: Tue, 9 Aug 2016 19:41:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs dev del hangs on 4.7
Message-ID: <20160809194142.GF9644@carfax.org.uk>
References: <20160809172758.GB9644@carfax.org.uk>
 <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
 <20160809182356.GC9644@carfax.org.uk>
 <b325a93d-47ca-be69-04b2-271cd7387506@fb.com>
 <20160809182733.GD9644@carfax.org.uk>
 <20160809191134.GE9644@carfax.org.uk>
 <4d0c6117-da81-b13f-667a-d36dcae7e979@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
In-Reply-To: <4d0c6117-da81-b13f-667a-d36dcae7e979@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 09, 2016 at 03:22:03PM -0400, Chris Mason wrote:
> 
> 
> On 08/09/2016 03:11 PM, Hugo Mills wrote:
> >On Tue, Aug 09, 2016 at 06:27:33PM +0000, Hugo Mills wrote:
> >>On Tue, Aug 09, 2016 at 02:26:14PM -0400, Chris Mason wrote:
> >>>On 08/09/2016 02:23 PM, Hugo Mills wrote:
> >>>>  Hi, Chris,
> >>>>
> >>>>On Tue, Aug 09, 2016 at 02:02:20PM -0400, Chris Mason wrote:
> >>>>>On 08/09/2016 01:27 PM, Hugo Mills wrote:
> >>>>>> Over the weekend, I started doing some maintenance on my server: I
> >>>>>>upgraded to 4.7.0, and I started deleting a device from my array,
> >>>>>>preparatory to putting in a larger one. About halfway through the
> >>>>>>operation, several kernel threads hung up for a while (resulting in
> >>>>>>"blocked for 120s" messages), and then the delete process seems to
> >>>>>>have stopped entirely, although several kernel threads are at maximum
> >>>>>>usage.
> >>>>>>
> >>>>>> After a few hours, I rebooted the machine, and left it for a day or
> >>>>>>so. I tried the delete again this afternoon, and it's done the same
> >>>>>>thing again. The full log is included below. I have a kworker and a
> >>>>>>btrfs-transaction pegged at close to 100% of a core each, and a
> >>>>>>btrfs-cleaner (and the btrfs dev del process) in D state.
> >>>>>>
> >>>>>> The FS was not under load at the time of the failure, and it passes
> >>>>>>scrub. I haven't tried a btrfs check yet.
> >>>>>
> >>>>>Thanks Hugo, can you nail down which line of code belongs to:
> >>>>>
> >>>>>btrfs_async_run_delayed_refs+0xc6
> >>>>
> >>>>  I'm having a spot of trouble with this. The btrfs on this kernel is
> >>>>built-in, and I've lost the contents of the build directory (it's done
> >>>>by an overnight build script, and it's already built a 4.8-rc1 for one
> >>>>of my other machines).
> >>>>
> >>>>(gdb) file /boot/vmlinuz-4.7.0-dirty
> >>>>BFD: /boot/vmlinuz-4.7.0-dirty: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
> >>>>Reading symbols from /boot/vmlinuz-4.7.0-dirty...(no debugging symbols found)...done.
> >>>>(gdb) list *btrfs_async_run_delayed_refs+0xc6
> >>>>No symbol table is loaded.  Use the "file" command.
> >>>>
> >>>>  There must be a way of getting this info from here, but I'm not
> >>>>sure I know what it is. Build a new kernel from 4.7 with this
> >>>>machine's config and run gdb on the btrfs.o file? Not a problem to do,
> >>>>but it might take a little while.
> >>>
> >>>As long as you use the same gcc and config file, it'll almost always
> >>>generate the same offsets/code.  You can recompile with debug
> >>>symbols on and it'll be accurate.
> >>
> >>   OK. Back later.
> >
> >(gdb) file fs/btrfs/btrfs.o
> >Reading symbols from fs/btrfs/btrfs.o...done.
> >(gdb) list *btrfs_async_run_delayed_refs+0xc6
> >0x13dae is in btrfs_async_run_delayed_refs (fs/btrfs/extent-tree.c:2915).
> >2910	
> >2911		btrfs_queue_work(root->fs_info->extent_workers, &async->work);
> >2912		
> >2913			if (wait) {
> >2914			   	  wait_for_completion(&async->wait);
> >2915						ret = async->error;
> >2916						      kfree(async);
> >2917								return ret;
> >2918								       }
> >2919									return 0;
> 
> So its waiting on the actual delayed ref work but we don't see them
> in the stack trace.
> 
> Can you please sysrq-w and sysrq-t?

   Not right now -- I wanted to watch a film, and rebooted the machine
to get NFS working again. It's now refusing to boot. I think that's
unrelated to this issue (different filesystems are involved for a
start), but it's stopping me from doing anything else. :(

   I'll reproduce the failure, and get back to you with the sysrq
dumps tomorrow.

   Hugo.

-- 
Hugo Mills             | You shouldn't anthropomorphise computers. They
hugo@... carfax.org.uk | really don't like that.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXqjH2AAoJEFheFHXiqx3kyPQQAK7NoD3iEHjJtaYiYgurZYoE
BocysO7xQXI9lx6KH0qfcHjKrmB+yW8PEqxRrKKi9iD1oz2sYpnbtS4O/7rhpK0C
D4jBdqMJme/c199M/JaagjmymFWKgoV74XfbPmni5B7wSijqmRRNXPzRgEHh50+M
5DLPKpw4pcytNEztk3qlBcqviKw25LcO9Uz7bscErplhT1NEwK4x3h5iCmO//U43
XCEQeOMxOozh2/mZ8aTrJipuBMl6kk/mi3ZHNZ4lN6LPkheKnAKRwrHPRMyqSr+i
aDa7Cyb5k0D8ces9+6HiL+Xv2RX6MPl6SKYEunaqdqPVuJPKjdvqhEOdjeRvziKa
lWjjCN0ttNmwLcEVKDFlXQdVIkKxgyfqJbttTainNXEDkwLlReYgJo3Z42ZFqxaP
g5iUa5cWUa6kx6/Gk2PX03NTuwMP/2hXMWHCl3/cFvMbOvYbm8msutgwqf7xTq7O
Ec9OVeBfeO5aIoseBkMhlLIFagiy7Bs0QM7RGXjhNvN504Y+tIxUB9Y121zvJObn
XOoQMv5414ip/aLmZfP+hx28yK283bRi939QFMG3hXxNTH8G6fsLSnMBUKTmM4Qp
0fmIqOoRrpBnA5rVgy2QniahwULAxspEQcgGflqyc55Z9Noh4+LINYRFuZmN9qAx
LzIHF5aTH45cysqnqNjY
=QSK5
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
