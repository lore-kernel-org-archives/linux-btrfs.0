From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to
 a filesystem
Date: Wed, 29 Sep 2010 14:19:14 +0200
Message-ID: <AANLkTi=yb0_y2=-TkgQMptxeg=9WkdAu2W78Escw=JfZ@mail.gmail.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com> <20100928232513.GA20629@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100928232513.GA20629@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 01:25, Christoph Hellwig <hch@infradead.org> wr=
ote:
> On Tue, Sep 28, 2010 at 04:53:16PM -0400, Josef Bacik wrote:
>> This was a request from the systemd guys. =C2=A0They need a quick an=
d easy way to get
>> all devices attached to a Btrfs filesystem in order to check if any =
of the disks
>> are SSD for...something, I didn't ask :). =C2=A0 I've tested this wi=
th the
>> btrfs-progs patch that accompanies this patch. =C2=A0Thanks,
>
> So please tell the "systemd guys" to explain what the fuck they're do=
ing
> to linux-fsdevel and fiend a proper interface. =C2=A0Chance is they w=
ill fuck
> up as much as just about ever other lowlevel userspace tool are very
> high.

=46uck like these comments make it incredibly hard to find the few
statements where you are right, in all the fucking noise you are
creating.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
