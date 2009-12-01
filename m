From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Tue, 1 Dec 2009 11:27:26 +0100
Message-ID: <23a15590912010227v38b62a51r63e5d83fdd9fec4c@mail.gmail.com>
References: <200911192026.04694.lists-receive@programmierforen.de>
	 <20091130042851.GG25509@jsoft.dyndns.org> <4B13C408.10606@hp.com>
	 <200911302025.22773.lists-receive@programmierforen.de>
	 <4B14B022.4080102@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
	lists-receive <lists-receive@programmierforen.de>,
	jowens <jowens@hp.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B14B022.4080102@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 1, 2009 at 6:56 AM, TARUISI Hiroaki
<taruishi.hiroak@jp.fujitsu.com> wrote:
> Btrfs collects block device information when mount or mkfs
> (device_list_add in volumes.c), and know devid-device relation
> by collected information. So, if we make filesystem on plain
> file, btrfs cannot know devid-device relation. As a result,
> btrfs cannot know which is 'devid=3Dn', and mount fails. Same as
> this, if collected relation is cleared by shutdown, mount fails.
>
> If we need to mount a filesystem without fail(cf, /etc/fstab line),
> we should specify 'device' options for every devices(except mount
> target device) like this.
>
> # mount -t btrfs -o device=3D/dev/loop2,device=3D/dev/loop3,
> =A0device=3D/dev/loop4 /dev/loop1 /mnt/
> =A0 (when a filesystem is constructed by /dev/loop[1-4])
>
> Regards,
> taruisi

Would this option ["mount -t btrfs -o device=3D/dev/sdb2 /dev/sda2
/mnt"] work on boot, bypasing the need for "btrfsctl -a" to mount a
multi-device filesystem?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
