From: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH] xfstests: add new getdents test
Date: Fri, 23 Sep 2011 16:03:41 +0300
Message-ID: <CANOLnOPm+BEQ0QOYnYRkJqpGPwyUD9D+23dJe2OwgrHXqYFyVA@mail.gmail.com>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
	<1316722702.2009.59.camel@doink>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: aelder@sgi.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316722702.2009.59.camel@doink>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2011 at 11:18 PM, Alex Elder <aelder@sgi.com> wrote:
> On Mon, 2011-09-12 at 03:19 +0300, Grazvydas Ignotas wrote:
>> The test checks if no duplicate d_off values are returned and that
>> those values are seekable to the right inodes.
>>
>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>
> I have two minor comments on the C program below,
> but even if you don't want to address them this
> looks good.
>
> Reviewed-by: Alex Elder <aelder@sgi.com>
>
> . . .
>
>> +#include <sys/syscall.h>
>> +
>> +struct linux_dirent64 {
>> + =A0 =A0 uint64_t =A0 =A0 =A0 =A0d_ino;
>> + =A0 =A0 uint64_t =A0 =A0 =A0 =A0d_off;
>> + =A0 =A0 unsigned short =A0d_reclen;
>> + =A0 =A0 unsigned char =A0 d_type;
>> + =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0d_name[0];
>> +};
>> +
>> +#define BUF_SIZE 4096
>> +#define HISTORY_LEN 1024
>> +
>> +static uint64_t d_off_histoty[HISTORY_LEN];
>> +static uint64_t d_ino_histoty[HISTORY_LEN];
>
> Is "histoty" intentional or a typo?

whoops, it's a typo. I might send a patch for this later.

>
>> +int
>> +main(int argc, char *argv[])
>> +{
>> + =A0 =A0 int fd, nread;
>> + =A0 =A0 char buf[BUF_SIZE];
>
> . . .
>
>> +
>> + =A0 =A0 /* check if seek works correctly */
>> + =A0 =A0 d =3D (struct linux_dirent64 *)buf;
>> + =A0 =A0 for (i =3D total - 1; i >=3D 0; i--)
>> + =A0 =A0 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 lret =3D lseek(fd, i > 0 ? d_off_histoty[i=
 - 1] : 0, SEEK_SET);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (lret =3D=3D -1) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 perror("lseek");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit(EXIT_FAILURE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 nread =3D syscall(SYS_getdents64, fd, buf,=
 BUF_SIZE);
>
> You could just use sizeof (struct linux_dirent_64) rather than
> BUF_SIZE here. =A0I suppose it doesn't hurt but there's no real
> sense in reading more than the one you're going to look at.

I'm not sure if reading partial entry is allowed, manpage says it may
fail with EINVAL if buffer size is too small..


--=20
Gra=FEvydas
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
