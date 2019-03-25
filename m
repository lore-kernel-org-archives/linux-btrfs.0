Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E674DC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A72EE20828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="ohUk8J0r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbfCYXHV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:07:21 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:28231 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfCYXHV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 19:07:21 -0400
Date:   Mon, 25 Mar 2019 23:07:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553555236;
        bh=uSndEBpMXmwvM94ujTuBDZXMFIAeWhfi0+X3cnuIMmI=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=ohUk8J0rtfjCfY2qzlq1o4etzt9oMOuI/ReuDvH4E21+cumR9sDhNOL+qRDvNEbsP
         7AQrj7MzKqHvuw0/Bo9KDtG611E5AUD7mLkI3/YohWUAezuBO6lMDMG2iW/RFZYfhA
         0jSE4DRF0M9GSmrQIW78RfNenrAChMpqFu2nHcO4=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: Re: parent transid verify failed / FS wont mount / help please!
Message-ID: <1CPBaYubCXknFwyEVx19WEr0AqqrHYDx41HvXDmySR5NonBx1zxoDUVebBkJdAX9_FPnPC3wFGlWXuG84MThTFJyRHzTS3sUQIjqKQoXdLg=@protonmail.com>
In-Reply-To: <20190325225657.GE27856@carfax.org.uk>
References: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
 <20190325223842.GC27856@carfax.org.uk>
 <kxQglfkZm7A_i8CXh0JVrJ9H0MF4vFVJWiT8BWRBc8NPM24nZC-vc6sIrts3ZR4T8HEvRTfPv1yz4lPotIuO1JiPYOk60cHMQqHcTFkDfZ4=@protonmail.com>
 <dJY4taBczsTC2XpF8mBue4O5brHguT2KuDS-bRHGA0fJ6m0o9z7bjHv0s2F6uvb0JZGISF-qkTWJT9bvl9ntyPbvq-FoOyQYCi0ZQ8_ShOw=@protonmail.com>
 <20190325225657.GE27856@carfax.org.uk>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Dear Hugo, please see below.

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Monday, 25. March 2019 23:56, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Mon, Mar 25, 2019 at 10:51:24PM +0000, berodual_xyz wrote:
>
> > Running "btrfs check" on the 3rd of the 4 devices the volume consists o=
f crashes with a trace:
>
> Just for the record, it doesn't matter which device you use for
> btrfs check. You're running it on the whole filesystem, not just one
> device. The device just serves to identify which FS you're running it
> on. (The btrfs check code will scan all the available block devices
> for the other pieces of the FS).
>
> Hugo.

I know and would have expected every device to give me the same output, but=
 it does not:

##
$ btrfs filesystem show
Label: 'FS1'  uuid: 8b00ff46-3f42-4f51-be6b-5ec8a7d8f2cd
=09Total devices 4 FS bytes used 54.91TiB
=09devid    1 size 21.83TiB used 13.75TiB path /dev/sdb
=09devid    2 size 21.83TiB used 13.75TiB path /dev/sdc
=09devid    3 size 21.83TiB used 13.75TiB path /dev/sdd
=09devid    4 size 21.83TiB used 13.75TiB path /dev/sde

##
$ btrfs check --readonly /dev/sdd
Opening filesystem to check...
parent transid verify failed on 1048576 wanted 60234 found 60230
parent transid verify failed on 1048576 wanted 60234 found 60230
Ignoring transid failure
volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
btrfs[0x426fdc]
btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
btrfs(btrfs_setup_all_roots+0x368)[0x416540]
btrfs[0x416a8a]
btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
btrfs(cmd_check+0x591)[0x45f431]
btrfs(main+0x24a)[0x40ca02]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f8480705b35]
btrfs[0x40c509]
[1]    479 abort      btrfs check --readonly /dev/sdd
##

Running "btrfs check --readonly /dev/sdc" (sdc is the 2nd device) returns:

##
$ btrfs check --readonly /dev/sdc
Opening filesystem to check...
parent transid verify failed on 55432763981824 wanted 60233 found 60235
parent transid verify failed on 55432763981824 wanted 60233 found 60235
Ignoring transid failure
parent transid verify failed on 55432753725440 wanted 60232 found 60235
parent transid verify failed on 55432753725440 wanted 60232 found 60235
Ignoring transid failure
parent transid verify failed on 55432764063744 wanted 60233 found 60235
parent transid verify failed on 55432764063744 wanted 60233 found 60235
Ignoring transid failure
parent transid verify failed on 55432747958272 wanted 60234 found 60235
parent transid verify failed on 55432747958272 wanted 60234 found 60235
Ignoring transid failure
Checking filesystem on /dev/sdc
UUID: 8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
[1/7] checking root items
Error: could not find extent items for root 268
ERROR: failed to repair root items: No such file or directory
##

By "tree dump" I refered to the output of "btrfs inspect-internal dump-tree=
"

My hope is that I can restore certain files by specifying their inode numbe=
r based on the tree info that I have, but I struggle to find a clear explan=
ation on how to do this.

Thank you, Hugo and all!





>
> > --
> >
> > $ btrfs check --readonly /dev/sdd
> > Opening filesystem to check...
> > parent transid verify failed on 1048576 wanted 60234 found 60230
> > parent transid verify failed on 1048576 wanted 60234 found 60230
> > Ignoring transid failure
> > volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
> > btrfs[0x426fdc]
> > btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
> > btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
> > btrfs(btrfs_setup_all_roots+0x368)[0x416540]
> > btrfs[0x416a8a]
> > btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
> > btrfs(cmd_check+0x591)[0x45f431]
> > btrfs(main+0x24a)[0x40ca02]
> > /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fa320a44b35]
> > btrfs[0x40c509]
> > [1] 22848 abort btrfs check --readonly /dev/sdd
> >
> > --
> >
> > Trying to mount "ro,usebackuproot" shows bad superblock and following e=
rrors in /var/log/messages:
> >
> > --
> >
> > 33814.360633] BTRFS info (device sdd): trying to use backup root at mou=
nt time
> > [33814.360637] BTRFS info (device sdd): using free space tree
> > [33814.360638] BTRFS info (device sdd): has skinny extents
> > [33814.361708] BTRFS error (device sdd): parent transid verify failed o=
n 1048576 wanted 60234 found 60230
> > [33814.361764] BTRFS error (device sdd): failed to read chunk root
> > [33814.373140] BTRFS error (device sdd): open_ctree failed
> >
> > --
> >
> > Again, thank you very much for all help!
> > Sent with ProtonMail Secure Email.
> > =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Origina=
l Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=
=90
> > On Monday, March 25, 2019 11:44 PM, berodual_xyz berodual_xyz@protonmai=
l.com wrote:
> >
> > > Thank you very much Hugo,
> > > the underlying devices are based on HW raid6 and effectively "stitche=
d" together. Loosing any of those would mean loosing all data, so much is c=
lear.
> > > My concern was not so much bitrod / silent data corruption but I woul=
d not have expected disabled data checksumming to be a disadvantage at reco=
vering from the supposed corruption now.
> > > Does anyone have any input on how to restore files based on inode no.=
 from the tree dump that I have?
> > > "usebackuproot,ro" did not succeed either.
> > > Much appreciate the input!
> > > Sent with ProtonMail Secure Email.
> > > =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Origi=
nal Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=
=90
> > > On Monday, March 25, 2019 11:38 PM, Hugo Mills hugo@carfax.org.uk wro=
te:
> > >
> > > > On Mon, Mar 25, 2019 at 10:26:29PM +0000, berodual_xyz wrote:
> > > >
> > > > > Dear all,
> > > > > on a large btrfs based filesystem (multi-device raid0 - all devic=
es okay, nodatacow,nodatasum...)
> > > >
> > > > Ouch. I think the only thing you could have done to make the FS
> > > > more fragile is mounting with nobarrier(). Frankly, anything you're
> > > > getting off it is a bonus. RAID-0 gives you no duplicate copy,
> > > > nodatacow implies nodatasum, and nodatasum doesn't even give you th=
e
> > > > ability to detect data corruption, let alone fix it.
> > > > With that configuration, I'd say pretty much by definition the
> > > > contents of the FS are considered to be discardable.
> > > > Restoring from backups is the recommended approach with transid
> > > > failures.
> > > > () Don't do that.
> > > >
> > > > > I experienced severe filesystem corruption, most likely due to a =
hard reset with inflight data.
> > > > > The system cannot mount (also not with "ro,nologreplay" / "nospac=
e_cache" etc.).
> > > >
> > > > Given how close the transids are, have you tried
> > > > "ro,usebackuproot"? That's about your only other option at this
> > > > point. But, if btrfs restore isn't working, then usebacuproot proba=
bly
> > > > won't either.
> > > >
> > > > > Running "btrfs restore" I got a reasonable amount of data backed =
up, but a large chunk is missing.
> > > > > "btrfs check" gives the following error:
>
> --
>
> Hugo Mills | I gave up smoking, drinking and sex once. It was the
> hugo@... carfax.org.uk | scariest 20 minutes of my life.
> http://carfax.org.uk/ |
> PGP: E2AB1DE4 |


