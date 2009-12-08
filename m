From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: committing new snapshots
Date: Tue, 8 Dec 2009 19:14:58 +0300
Message-ID: <2a31deca0912080814h48ce18f6j85f8d3e37aa3881c@mail.gmail.com>
References: <Pine.LNX.4.64.0912071411560.31714@cobra.newdream.net>
	<20091208160507.GA3374@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091208160507.GA3374@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 8, 2009 at 7:05 PM, Josef Bacik <josef@redhat.com> wrote:
> On Mon, Dec 07, 2009 at 02:25:50PM -0800, Sage Weil wrote:
>> When you create a new snap or subvol, first a new ROOT_ITEM is creat=
ed
>> while everything commits, and then the referring directory entry is =
set up
>> (with a correspond ROOT_BACKREF).
>>
>> First, if you say 'btrfsctl -s foo .' and then 'reboot -f -n' before=
 the
>> next regularly scheduled commit, the snap is created, but lost.. the=
re's
>> no reference. =A0Second, the unreferenced ROOT_ITEM is never cleaned=
 up.
>>
>> Are there any existing plans for this? =A0It would be nice if the re=
ference
>> could be committed as well the first time around. =A0That probably r=
equires
>> a bit of futzing to determine what the root objectid is going to be
>> beforehand, then adding the link in the namespace, then flushing thi=
ngs
>> out and updating the root item in the right order?
>>
>
> We could probably use the orphan code for this. =A0Just create an orp=
han item for
> the snapshot and then delete it when the snapshot is fully created th=
at way if
> somebody does reboot -fn we cleanup the root item and such. =A0Thanks=
,
>

It would be nice to have atomic behavior. Perhaps something similar to
rename with its atomicity guarantees could help?

Regards,
Andrey


> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
