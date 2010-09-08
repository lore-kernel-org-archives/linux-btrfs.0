From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: btrfs and raid1 (restore)
Date: Tue, 7 Sep 2010 20:46:19 -0400
Message-ID: <-3598551969956434661@unknownmsgid>
References: <20100907222807.GA3546@scooter>
Mime-Version: 1.0 (iPhone Mail 8A400)
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100907222807.GA3546@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

Now that we know the facts, what is the problem? Some simple questions first;
Is the data still accessible?
What did the rebalance do?
Output of btrfsck/dmesg?
mkfs.vfat does not write much on disk so if the rebalance was also
made before the mkfs I guess most data is still present.

Sent from my mobile device.

On 2010-09-07, at 18:28, Felix Blanke <felixblanke@gmail.com> wrote:

> Hi,
>
> I made a REALLY bad mistake today.
>
> I've two hdds which are running at raid1 via btrfs. Today I mistyped a device-node
> and did a "mkfs.vfat" on one of them.
>
> Then I simply did a "btrfs filesystem balance /path/". "btrfs filesystem show /path/"
> now looks like this:
>
> Label: 'home1'  uuid: c3c38f32-f176-4479-8c44-e832ea64639f
>    Total devices 2 FS bytes used 226.12GB
>    devid    2 size 465.76GB used 114.38GB path /dev/loop3
>    devid    1 size 465.76GB used 114.39GB path /dev/loop4
>
>
> Before my mistake the "FS bytes used" were all three the same, now the bottom two are
> only half of the size. Am I right that those devices didnt run in raid1 mode anymore?
> :(
>
>
> Is there a way, without copying back all data from my backup, to get those 2 running in
> raid1 mode?
> Or do I have to make a "mkfs.btrfs -m raid1 -d raid1 /dev/1", "btrfs device add /dev/2" and
> "btrfs filesystem balance /path/"? :/ That would cost a lot of time.
>
>
> Thanks for your help!
>
>
> Regards,
> Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
