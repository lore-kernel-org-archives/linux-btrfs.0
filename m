From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Adding mirroring to an existing filesystem
Date: Sun, 16 May 2010 12:31:55 -0700
Message-ID: <AANLkTikKYC5XIkgiOe1hF2Gg4Rz6nM2Ab4Z_YbgZjM4A@mail.gmail.com>
References: <AANLkTimKr24mjku0shVSNmUSd9yW6MgeBBIIYuPsE7BN@mail.gmail.com>
	 <677718.82116.qm@web112502.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Donald Gordon <don@dis.org.nz>
To: J G <yoosty_cmn@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <677718.82116.qm@web112502.mail.gq1.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 16, 2010 at 8:38 AM, J G <yoosty_cmn@yahoo.com> wrote:
>
>
> --- On Sun, 5/16/10, Donald Gordon <don@dis.org.nz> wrote:
>
>> From: Donald Gordon <don@dis.org.nz>
>> Subject: Adding mirroring to an existing filesystem
>> To: linux-btrfs@vger.kernel.org
>> Date: Sunday, May 16, 2010, 4:39 AM
>> Hi
>>
>> Is there some way I can add an extra disk as a mirror to an
>> existing
>> btrfs filesystem?=C2=A0 Or must I create a new filesystem
>> with RAID1, and
>> then copy over all my data?
>
> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Dev=
ices#Adding_New_Devices
>
> I would be sure to back my data up before performing this procedure ;=
)

You should have good backups and keep having good backups before and
during the use of btrfs.  Period.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
