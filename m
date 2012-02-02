From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH 12/12] Btrfs: Fix file clone when source offset is not 0
Date: Thu, 2 Feb 2012 14:44:08 +0800
Message-ID: <CAAM7YAk7xa7BVov5LdHgEzsTJF7+ot4yk53NVavS2SPvnqNqKw@mail.gmail.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
	<4D4130D4.2000001@cn.fujitsu.com>
	<CAAM7YA=fCFfv-qObkpovQ6D7_6BdT1xU1c-0sVJNWjmPYHQBiw@mail.gmail.com>
	<4F2A1FA5.9020606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F2A1FA5.9020606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 2, 2012 at 1:31 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Yan, Zheng wrote:
>> On Thu, Jan 27, 2011 at 4:46 PM, Li Zefan <lizf@cn.fujitsu.com> wrot=
e:
>>> Suppose:
>>> - the source extent is: [0, 100]
>>> - the src offset is 10
>>> - the clone length is 90
>>> - the dest offset is 0
>>>
>>> This statement:
>>>
>>> =A0 =A0 =A0 =A0new_key.offset =3D key.offset + destoff - off
>>>
>>> will produce such an extent for the dest file:
>>>
>>> =A0 =A0 =A0 =A0[ino, BTRFS_EXTENT_DATA_KEY, -10]
>>>
>>> , which is obviously wrong.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>> ---
>>> =A0fs/btrfs/ioctl.c | =A0 =A05 ++++-
>>> =A01 files changed, 4 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index f87552a..1b61dab 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -1788,7 +1788,10 @@ static noinline long btrfs_ioctl_clone(struc=
t file *file, unsigned long srcfd,
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(&new_key, &ke=
y, sizeof(new_key));
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_key.objectid =3D=
 inode->i_ino;
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.offset =3D ke=
y.offset + destoff - off;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (off <=3D key.offs=
et)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_k=
ey.offset =3D key.offset + destoff - off;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_k=
ey.offset =3D destoff;
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0trans =3D btrfs_star=
t_transaction(root, 1);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(trans)) {
>>
>> This is a disk format change, will cause Oops when deleting or
>> truncating the file.
>>
>
> This is a bug fix, never mean to make a change on disk format. I'll
> appreciate if you point out what exactly is wrong in this fix.

sorry, I was misleaded by the backref discuss, your fix is correct
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
