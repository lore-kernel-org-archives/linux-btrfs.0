From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH, fixed] Prevent oopsing in posix_acl_valid()
Date: Tue, 10 May 2011 13:42:45 +0800
Message-ID: <BANLkTinf-DQmmG==JNndPtLRCaAB3zV1XA@mail.gmail.com>
References: <1304477648-14952-1-git-send-email-daniel.blueman@gmail.com>
	<4DC16572.8020005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>, Christian Brunner <chb@muc.de>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC16572.8020005@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 4 May 2011 22:40, Josef Bacik <josef@redhat.com> wrote:
> On 05/03/2011 10:54 PM, Daniel J Blueman wrote:
>>
>> If posix_acl_from_xattr() returns an error code, a negative address =
is
>> dereferenced causing an oops; fix by checking for an error code firs=
t.
>>
>> Typo fixed; too much late-night coding.
>>
>> Signed-off-by: Daniel J Blueman<daniel.blueman@gmail.com>
>> ---
>> =A0fs/btrfs/acl.c | =A0 =A05 +++--
>> =A01 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index 5d505aa..44ea5b9 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -178,12 +178,13 @@ static int btrfs_xattr_acl_set(struct dentry
>> *dentry, const char *name,
>>
>> =A0 =A0 =A0 =A0if (value) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0acl =3D posix_acl_from_xattr(value, s=
ize);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(acl))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (acl) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D posix_acl_val=
id(acl);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto =
out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (IS_ERR(acl)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(acl);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>>
>
> Actually pulled this down and compiled it this time to make sure it w=
orked.
> =A0You can add
>
> Reviewed-by: Josef Bacik <josef@redhat.com>

Will this fix go upstream for the final 2.6.39, now that the last -rc
is already out? I hit it in two independent cases when rebooting after
other kernel crashes.

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
