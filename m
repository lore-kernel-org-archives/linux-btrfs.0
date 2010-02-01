From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: panic during rebalance, and now upon mount
Date: Mon, 1 Feb 2010 12:22:46 +0800
Message-ID: <3d0408631001312022o18dea69t5e0f1403c02388c3@mail.gmail.com>
References: <4B63CC39.1020505@gmail.com>
	 <3d0408631001300409i13326d13vac10a3f639f6db92@mail.gmail.com>
	 <4B646D08.1020307@gmail.com>
	 <3d0408631001301800y5de8a412w1d29bdb5e5e79f84@mail.gmail.com>
	 <4B6556C9.7060809@gmail.com>
	 <3d0408631001310434g35b1fa4cp8a42068ef5fa5a34@mail.gmail.com>
	 <4B65DB18.60309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Troy Ablan <tablan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B65DB18.60309@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 1, 2010 at 3:33 AM, Troy Ablan <tablan@gmail.com> wrote:
> Yan, Zheng wrote:
>> Please try the patch attached below. It should solve the bug during
>> mounting
>> that fs. But I don't know why there are so many link count errors in=
 that fs.
>> How old is that fs? what was that fs used for?
>>
>> Thank you very much.
>> Yan, Zheng
>>
>>
> Good, so far. =A0Thanks!
>
> The filesystem is less than 2 weeks old, created and managed exclusiv=
ely
> with the unstable tools Btrfs v0.19-4-gab8fb4c-dirty
>
> I created the filesystem -d raid1 -m raid1.
>
> There are 14 dm-crypt mappings corresponding to 14 partitions on 14
> drives. =A0There's one filesystem made up from these devices with abo=
ut 14
> TB of space (a mixture of devices ranging from 500GB to 2TB)
>
> The filesystem is used for incremental backup from remote computers
> using rsync.
>
> The filesystem tree is as follows
>
> /
> /machine1 <- normal directory
> /machine1/machine1 <- a subvolume
> /machine1/machine1-20100120-1220 <- a snapshot of the subvolume above
> ....
> /machine1/machine1-20100131-1220 <- more snapshots of the subvolume a=
bove
> /machine2 <- normal directory
> /machine2/machine1 <- a subvolume
> /machine2/machine2-20100120-1020 <- a snapshot of the subvolume above
> ....
> /machine2/machine2-20100131-1020 <- more snapshots of the subvolume a=
bove
> ....
>
> The files are backed up with `rsync -aH --inplace` onto the subvolume
> for each machine.
>
> The only oddness I can think of is that during initial testing of thi=
s
> filesystem, I yanked a drive physically from the machine while it was
> writing. =A0btrfs seemed to continue to try to write to the inaccessi=
ble
> device, and indeed, btrfs-show showed the used space on the missing
> drive increasing over time. =A0Also, I was unable to remove the drive=
 from
> the volume (ioctl returned -1), so it was in this state until I reboo=
ted
> a couple hours later. =A0 I then did a btrfs-vol -r missing on the dr=
ive,
> and then added it back in as a new device. =A0I did btrfs-vol -b whic=
h
> succeeded once. =A0 After adding more drives, I did btrfs-vol -b agai=
n,
> and that left me in the state where this thread began.
>
> As I understand it, a btrfs-vol -b is currently one of the only ways =
to
> reduplicate unmirrored chunks after a drive failure. (aside from
> rewriting the data or removing and readding devices). =A0Is my
> understanding correct?
>
Yes,

Thanks again for helping debug.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
