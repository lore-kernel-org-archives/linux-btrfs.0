Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55841 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3DOQpd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 12:45:33 -0400
Received: by mail-ob0-f174.google.com with SMTP id wm15so4304913obc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 09:45:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
	<1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
	<CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
Date: Mon, 15 Apr 2013 12:45:32 -0400
Message-ID: <CAK82gMGSGaNywR=RkEQcNbQiMW5-z2O3ZqkMwKtamEdRH+A7aQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
From: Dan McGrath <danmcgrath.ca@gmail.com>
To: Jan Alexander Steffens <jan.steffens@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan,

I got a chance to sit down and dig a little bit deeper into
`fsck.xfs`. Here is what I discovered.

The "(a|A|y|p)" options in the XFS script appear to be nothing more
than the expected `fsck` options that imply automated checks (as is
clearly implied by the use of AUTO). While I have yet to specifically
test the capitalized "A", my guess is that it matches the "-A" options
from fsck(8) for when the system is going through the fstab. The
syntax itself appears to assume that the dev name is the last param
(as indicated by the argc/$#, which gets eval'd into the DEV
variable).

After doing some tests with a hacked up version of the `fsck.xfs`
script, it would appear that the generic `fsck` script calls each
script in order and passes it some parameters to test, since if I pass
`fsck` some random/btrfsck switches:

  # fsck --repair /dev/storage/lv_btrfs

I get an error back from `fsck.ext4`:

  fsck from util-linux 2.20.1
  fsck.ext4: invalid option -- 'e'

Since the man page for fsck(8) hints that there are no real standards
for calling conventions, but most support (a|n|r|y), and as how
unknown options cause an error with fsck (thanks to ext4), perhaps it
would be a good idea for btrfsck to align itself with the standard
options for fsck (a/n/r/y/A)? If anything, the "A" option (for fstab
based) would appear to be the real target of a noop style exit(0) that
I had originally tested.

Also, thanks for the link Eric, just came in as I am typing this reply :)

Anyways, thought I would reply back with some insight on the matter
and see what others had to say, since I am in no position to dictate
the direction that brtfsck/fsck.btrfs should take as far as wrapper
script or no is concerned. Look forward to your replies! o/


Dan

On Mon, Apr 15, 2013 at 10:03 AM, Jan Alexander Steffens
<jan.steffens@gmail.com> wrote:
> On Mon, Apr 15, 2013 at 3:47 PM, Dan McGrath <danmcgrath.ca@gmail.com> wrote:
>> As per FAQ: It is safe to and recommended to turn fsck.btrfs into a no-op
>>
>> Signed-off-by: Dan McGrath <danmcgrath.ca@gmail.com>
>> ---
>>  btrfs.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/btrfs.c b/btrfs.c
>> index 691adef..78161a9 100644
>> --- a/btrfs.c
>> +++ b/btrfs.c
>> @@ -272,6 +272,8 @@ int main(int argc, char **argv)
>>
>>         if (!strcmp(bname, "btrfsck")) {
>>                 argv[0] = "check";
>> +       } else if (!strcmp(bname, "fsck.btrfsck")) {
>> +               exit(0);
>>         } else {
>>                 argc--;
>>                 argv++;
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Shouldn't it be fsck.btrfs, not fsck.btrfsck?
>
> Also, fsck.xfs does a bit more than just an exit(0), maybe there's
> some merit to what it does. It's a simple shellscript, so check it
> out.
