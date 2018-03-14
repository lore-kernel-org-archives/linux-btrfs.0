Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v150-95-217-78.ll6w.static.cnode.io ([150.95.217.78]:60800 "EHLO
        mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbeCNHjb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 03:39:31 -0400
Date: Wed, 14 Mar 2018 16:33:16 +0900
From: "MASAKI, " Aki " Yuhsuke" <aki@reasonset.net>
To: MASAKI haruka <yek@reasonset.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs broken in massive transfar
Message-Id: <20180314163316.4641e2c9dd51fe504a05b34a@reasonset.net>
In-Reply-To: <20180314135613.4ef005f0b93cb2888abd9750@reasonset.net>
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
        <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
        <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
        <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com>
        <20180314042507.f20bbf949ce07f88ca01cb38@reasonset.net>
        <CAJCQCtRaUUSWOWGQzJqZVddV9639O0B8eiZzNKTB0DPYowLWoA@mail.gmail.com>
        <20180314135613.4ef005f0b93cb2888abd9750@reasonset.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changing crypt layer didn't solve this probrem...


> > On Tue, Mar 13, 2018 at 1:25 PM, MASAKI haruka <yek@reasonset.net> wrote:
> > > journal(Kernel log), 7th try (to be readonly):
> > >
> > > ---
> > >  3月 12 16:25:51 lily kernel: BTRFS info (device dm-6): creating UUID tree
> > >  3月 12 16:25:53 lily iscsid[1406]: Connection-1:0 to [target: iqn.1994-11.com.netgear:eggplant-01:edc9adcf:btr1group, portal: 192.168.1.166,3260] through [iface: default] is shutdown.
> > >  3月 12 16:25:53 lily iscsid[1406]: IPC qtask write failed: Broken pipe
> > >  3月 12 16:26:18 lily kernel:  connection1:0: detected conn error (1020)
> > >  3月 12 16:26:19 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
> > >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> > >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 Sense Key : 0x2 [current] [descriptor]
> > >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 ASC=0x8 ASCQ=0x0
> > >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 CDB: opcode=0x8a 8a 00 00 00 00 00 00 42 5c 00 00 00 34 00 00 00
> > >  3月 12 16:26:21 lily kernel: print_req_error: I/O error, dev sdg, sector 4348928
> > 
> > 
> > Looks like network problems. Is one of these Btrfs volumes on an iSCSI
> > device? Because there's a bunch of iSCSI errors followed by an I/O
> > error with sector LBA reported, and then you get a bunch of Btrfs
> > write errors.
> > 
> > What's the relationship between /dev/sdg and device (dm-6)
> > /dev/mapper/hymaster_1 ?
> > 
> 
> 
> /dev/mapper/hymaster_1 is dm-crypt plain device.
> Its real device is /dev/sdg it is an iSCSI disk
> connected to NAS over GbE link local.
> 
> If this probrem from network, it's looked difficult to solve
> because I tried with two different computers without any other network device...
> 
> > 
> > >
> > > Note: This system's structure is;
> > > Computer (Linux 4.14/4.15) - btrfs (original) - dm-crypt plain - internal 4 disks
> > >  \_ btrfs (destination) - dm-crypt plain - iSCSI (single) - NAS - Hardware RAID5 - 8 disks
> > 
> > dm-6 is what btrfs is directly using and is complaining about, and I
> > will guess that this is a dmcrypt device backed by /dev/sdg which is
> > iSCSI to the NAS. Correct? Looks like either network problems, or
> > possibly there is a real hardware problem with an error that's only
> > partly passing through iSCSI. I can't parse this:
> > 
> >  3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 UNKNOWN(0x2003)
> > Result: hostbyte=0x00 driverbyte=0x08
> >  3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 Sense Key : 0x2
> > [current] [descriptor]
> >  3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 ASC=0x8 ASCQ=0x0
> >  3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 CDB: opcode=0x8a
> > 8a 00 00 00 00 00 cd 6f 0b 80 00 00 2a 20 00 00
> > 
> > Anyway, Btrfs detects the write failures, and is going read-only in
> > order to prevent corrupting the file system. So I think you've got
> > some iSCSI troubleshooting to do, and fix that. Doesn't seem like it's
> > a Btrfs specific problem to me.
> > 
> 
> > and I will guess that this is a dmcrypt device backed by /dev/sdg which is
> > iSCSI to the NAS. Correct?
> 
> Yes.
> 
> The log looks network (disk?) probrem me too, but I think it is unlikely
> because I didn't used iSCSI in case of I experienced (when Linux 3.9.)
> Altough then btrfs disks are little unstable, so it's guessable that
> target device (disks, iSCSI or network) reason...
> 
> I didn't see iSCSI error without btrfs transfaring.
> I thought if most people didn't see probrem like this,
> maybe the reason is some difference... dm-crypt plain?
> 
> I'm trying to use encrypt function on NAS (LUKS?) instead of dm-crypt plain on iSCSI disk.
> 
> (I don't know how to find iSCSI probrem...)
> 
> Thank you.
> 
> > -- 
> > Chris Murphy
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> MASAKI haruka <yek@reasonset.net>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
MASAKI, "Aki" Yuhsuke <aki@reasonset.net>
