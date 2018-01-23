Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:40385 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932111AbeAWUqW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 15:46:22 -0500
Received: by mail-ot0-f195.google.com with SMTP id x4so1651533otg.7
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 12:46:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180123194216.GQ15713@twin.jikos.cz>
References: <1515362061-13281-1-git-send-email-rosenp@gmail.com> <20180123194216.GQ15713@twin.jikos.cz>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 23 Jan 2018 12:46:21 -0800
Message-ID: <CAKxU2N9tN5fb=gqU30igTsH8SpoXAWtWoRuZ_g_AB6SExEzmgg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: treewide: Replace strerror(errno) with %m.
To: dsterba@suse.cz, Rosen Penev <rosenp@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 11:42 AM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Jan 07, 2018 at 01:54:21PM -0800, Rosen Penev wrote:
>> As btrfs is specific to Linux, %m can be used instead of strerror(errno)
>> in format strings. This has some size reduction benefits for embedded
>> systems.
>
> Makes sense.
>
>> glibc, musl, and uclibc-ng all support %m as a modifier to printf.
>> A quick glance at the BIONIC libc source indicates that it has
>> support for %m as well. BSDs and Windows do not but I do believe
>> them to be beyond the scope of btrfs-progs.
>
> Thanks for checking the compatibility. The %m can be substituted
> by a wrapper if this becomes a problem in the future.
>
>> Compiled sizes on Ubuntu 16.04:
>>
>> Before:
>> 3916512 btrfs
>
>> After:
>> 3908744 btrfs
>
> the delta is about 7KiB, that's not much but still counts. I would not
> object further optimizations towards size reduction as long as the code
> remains maintainable.
>
>> 233256  libbtrfs.so.0.1
>> 4899    bcp
>> 2366560 btrfs-convert
>> 2207432 btrfs-corrupt-block
>> 13302   btrfs-debugfs
>> 2151104 btrfs-debug-tree
>> 2134968 btrfs-find-root
>> 2281864 btrfs-image
>> 2143536 btrfs-map-logical
>> 2129704 btrfs-select-super
>> 2151552 btrfstune
>> 2130696 btrfs-zero-log
>> 2276272 mkfs.btrfs
>
> Some of the utilities are typically installed by default, the binaries
> share a lot of code as they get built from the same object files. I had
> once an idea of a compound binary that would switch the function by the
> name of the executable. Similar to what busybox does.
>
> https://github.com/kdave/btrfs-progs/commit/8fc697a7f763f39f3afe0abaa68ac13a49ac8a86
>
> ---
> * btrfs
> * mkfs.btrfs
> * btrfstun
> * btrfs-image
> * btrfs-convert
> * btrfs-debug-tree
> * btrfs-show-super
> * btrfs-find-root
>
> The static target is also supported. The name of resulting boxed
> binaries is btrfs.box and btrfs.box.static .
>
>    text    data     bss     dec     hex filename
>  550988   19120   15444  585552   8ef50 btrfs
> 1562099   25316   42256 1629671  18dde7 btrfs.static
>  659504   21104   16492  697100   aa30c btrfs.box
> 1817274   27988   44088 1889350  1cd446 btrfs.box.static
> ---
>
> I was not sure if this is was just another good idea waiting for a usecase (or
> not), so I haven't continued past the prototype. Please let me know if you'd be
> interested in this functionality, the patch is fairly trivial to update.
Sounds pretty useful. To clarify, I use btrfs on an OpenWrt system
with 32MB of flash(8MB is more common). Anything I can get is useful.
>
>> @@ -815,7 +815,7 @@ static const char * const cmd_filesystem_sync_usage[] = {
>>
>>  static int cmd_filesystem_sync(int argc, char **argv)
>>  {
>> -     int     fd, res, e;
>> +     int     fd, res;
>>       char    *path;
>>       DIR     *dirstream = NULL;
>>
>> @@ -831,10 +831,9 @@ static int cmd_filesystem_sync(int argc, char **argv)
>>               return 1;
>>
>>       res = ioctl(fd, BTRFS_IOC_SYNC);
>> -     e = errno;
>>       close_file_or_dir(fd, dirstream);
>>       if( res < 0 ){
>> -             error("sync ioctl failed on '%s': %s", path, strerror(e));
>> +             error("sync ioctl failed on '%s': %m", path);
>
> Let me use that one as example, there are a few more similar updates.
>
> There's potentially lost errno from the ioctl if something inside
> close_file_or_dir() overwrites it, as there are closedir and close. This
> is highly unlikely and I'll deal with that separately, so I'm going to
> apply the patch without further changes. Thanks.
Ah I didn't realize that's what the variable was used for. Makes sense.
