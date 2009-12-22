From: liu weni <qingshenlwy@gmail.com>
Subject: Re: [PATCHv2 02/12]posix_acl: Add the check items
Date: Tue, 22 Dec 2009 22:31:38 +0800
Message-ID: <b3657a100912220631n4d69ea66x23c1296e1abc468a@mail.gmail.com>
References: <4B2F619A.8000407@gmail.com>
	 <20091222120803.GR18217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, joel.becker@oracle.com, cjb@laptop.org,
	jmorris@namei.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, onlyflyer@gmail.com,
	strongzgy@gmail.com
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753029AbZLVObl@vger.kernel.org>
In-Reply-To: <20091222120803.GR18217@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All:

    I'm sorry for my stupid. I am crazy for fixing this bug.
And make so much mistake.
Maybe I need cool down and think more.

--
Best Regards,
Liuwenyi
2009-12-22



2009/12/22 Al Viro <viro@zeniv.linux.org.uk>:
> On Mon, Dec 21, 2009 at 07:52:58PM +0800, Liuwenyi wrote:
>> @@ -102,12 +102,9 @@ static int btrfs_set_acl(struct btrfs_trans_han=
dle
>> *trans,
>> char *value =3D NULL;
>> mode_t mode;
>>
>> - if (acl) {
>> - ret =3D posix_acl_valid(acl);
>> - if (ret < 0)
>> - return ret;
>> - ret =3D 0;
>> - }
>> + ret =3D posix_acl_valid(acl);
>> + if (ret < 0)
>> + return ret;
>
> ... and now you can't remove acl from btrfs inode. =A0At all.
>
> NAK the entire series. =A0You are changing existing user-visible beha=
viour
> for all filesystems for no reason and at least in this case it's clea=
rly
> wrong change.
>
