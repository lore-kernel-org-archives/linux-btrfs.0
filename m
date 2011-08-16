From: Espen Trydal <espen.trydal@gmail.com>
Subject: Re: btrfs: failed to read chunk root
Date: Tue, 16 Aug 2011 16:37:42 +0000
Message-ID: <CAAaHQFW6CBRLa1Z1XFgmDvuu4QnPWo8ohjFAQz34+2Ev0tq9QA@mail.gmail.com>
References: <CAAaHQFUUvwo=s2UbLz1ZNBNHb7MukFc8X4J+A0LRwka6KfBvng@mail.gmail.com>
 <CAAaHQFWhDPjPWF_YA2Ag-DcmGXKiPt3_XY79nZrCNn+fB-AjdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAaHQFWhDPjPWF_YA2Ag-DcmGXKiPt3_XY79nZrCNn+fB-AjdQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just out of curiosity, even if there is no solution to my problem at
the moment, could somebody explain to me what this error means and
what happened? As far as I know it was just a normal reboot. Hardware
failure (so a mirrored device would have saved it) or software
failure?

Regards,
Espen


2011/8/14 Espen Trydal <espen.trydal@gmail.com>:
> Hello,
>
> trying out btrfs on my linux installation. I am running Funtoo with
> Linux 3.0 kernel. After a reboot kernel panicked (no access to error
> log since it is my root volume that failed). I get this using a rescu=
e
> cd (2.6.38, btrfs v 0.19) and then trying to mount :
>
> [=C2=A0 752.129118] btrfs bad tree block start 0 131072
> [=C2=A0 752.129152] btrfs: failed to read chunk root on sda5
> [=C2=A0 752.132190] btrfs: open_ctree failed
> [ 1132.984600] device label deux devid 1 transid 86 /dev/sdb3
> [ 1171.796682] device fsid 9d42de57e2bebde7-4824b05acb3c538d devid 1
> transid 346 /dev/sda5
>
> Trying btrfsck:
> btrfsck: disk-io.c:721: open_ctree_fd: Assertion `!(!chunk_root->node=
)' failed.
>
> It had worked alright during the last couple of reboots. Before
> rebooting I created a new btrfs volume which I am able to mount
> without problems in rescue mode.
>
> Thanks for any help,
> Espen
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
