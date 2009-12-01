From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Wed, 02 Dec 2009 08:52:40 +0900
Message-ID: <4B15AC48.6040506@jp.fujitsu.com>
References: <200911192026.04694.lists-receive@programmierforen.de>	 <20091130042851.GG25509@jsoft.dyndns.org> <4B13C408.10606@hp.com>	 <200911302025.22773.lists-receive@programmierforen.de>	 <4B14B022.4080102@jp.fujitsu.com> <23a15590912010227v38b62a51r63e5d83fdd9fec4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: lists-receive@programmierforen.de, jowens@hp.com,
	linux-btrfs@vger.kernel.org
To: skolima@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15590912010227v38b62a51r63e5d83fdd9fec4c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yes. 'device' options work good on boot.
(There may be trivial differences, perhaps.)

Both 'btrfsctl -a|A' and device option of mount calls a same
device collection function, 'scan_one_device' and by this
function btrfs knows devices for btrfs.

# But, there's no mount option like 'btrfsctl -a', so
# option string grows longer and longer as number of
# devices increases...

Leszek Ciesielski wrote:
> On Tue, Dec 1, 2009 at 6:56 AM, TARUISI Hiroaki
> <taruishi.hiroak@jp.fujitsu.com> wrote:
>> Btrfs collects block device information when mount or mkfs
>> (device_list_add in volumes.c), and know devid-device relation
>> by collected information. So, if we make filesystem on plain
>> file, btrfs cannot know devid-device relation. As a result,
>> btrfs cannot know which is 'devid=n', and mount fails. Same as
>> this, if collected relation is cleared by shutdown, mount fails.
>>
>> If wlee need to mount a filesystem without fail(cf, /etc/fstab line),
>> we should specify 'device' options for every devices(except mount
>> target device) like this.
>>
>> # mount -t btrfs -o device=/dev/loop2,device=/dev/loop3,
>>  device=/dev/loop4 /dev/loop1 /mnt/
>>   (when a filesystem is constructed by /dev/loop[1-4])
>>
>> Regards,
>> taruisi
> 
> Would this option ["mount -t btrfs -o device=/dev/sdb2 /dev/sda2
> /mnt"] work on boot, bypasing the need for "btrfsctl -a" to mount a
> multi-device filesystem?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
taruisi

