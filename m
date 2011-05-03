From: Christian Brunner <chb@muc.de>
Subject: Re: [PATCH] Prevent oopsing in posix_acl_valid()
Date: Tue, 3 May 2011 21:33:52 +0200
Message-ID: <BANLkTinm6n5sm77Rc=yvXk4M-uqL7=_oNQ@mail.gmail.com>
References: <1304441053-4173-1-git-send-email-daniel.blueman@gmail.com>
	<4DC03D7E.1020908@redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC03D7E.1020908@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/3 Josef Bacik <josef@redhat.com>:
> On 05/03/2011 12:44 PM, Daniel J Blueman wrote:
>>
>> If posix_acl_from_xattr() returns an error code, a negative address =
is
>> dereferenced causing an oops; fix by checking for error code first.
>>
>> Signed-off-by: Daniel J Blueman<daniel.blueman@gmail.com>
>> ---
>> =A0fs/btrfs/acl.c | =A0 =A05 +++--
>> =A01 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 5d505aa..cad6fbb 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -178,12 +178,13 @@ static int btrfs_xattr_acl_set(struct dentry
>> *dentry, const char *name,
>>
>> =A0 =A0 =A0 =A0if (value) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0acl =3D posix_acl_from_xattr(value, s=
ize);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl)

A small typo: The right parenthesis is missing.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
