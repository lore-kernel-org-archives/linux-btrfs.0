From: Alan Chandler <alan@chandlerfamily.org.uk>
Subject: Re: Synching a Backup Server
Date: Sun, 09 Jan 2011 15:32:24 +0000
Message-ID: <4D29D508.6080006@chandlerfamily.org.uk>
References: <201101060935.14059.CACook@quantum-sci.com>	<201101061342.23991.CACook@quantum-sci.com>	<AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>	<201101071720.08298.hka@qbs.com.pl>	<4D29A033.7000803@chandlerfamily.org.uk> <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



On 09/01/11 13:54, Fajar A. Nugraha wrote:
>
> By default, when you do something like
>
> mount /dev/sdb1 /mnt/btrfs
>
> the default subvolume will be mounted under /mnt/btrfs. Snapshots and
> subvolumes will be visible as subdirectories under it, regardless
> whether it's in the root or several directories under it. Most likely
> this is enough for what you need, no need to mess with mounting
> subvolumes.
>
> Mounting subvolumes allows you to see a particular subvolume directly
> WITHOUT having to see the default subvolume or other subvolumes. This
> is particularly useful when you use btrfs as "/" or "/home" and want
> to "rollback" to a previous snapshot. So assuming "snapshots-server-b"
> above is a snapshot, you can run
>
>
>    

I think I start to get it now.  Its the fact that subvolumes can be 
snapshotted etc without mounting them that is the difference.  I guess I 
am too used to thinking like LVM and I was thinking subvolumes where 
like an LV.  They are, but not quite the same.

-- 
Alan Chandler
http://www.chandlerfamily.org.uk

