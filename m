Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35565 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYJP7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 05:15:59 -0400
Received: by obbuo13 with SMTP id uo13so807008obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 02:15:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqBco7__Gjby0j-JjOnd1h7Fh5ECq7BW4U1ubE=boQr0eg@mail.gmail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
	<1341409174-13619-7-git-send-email-ablock84@googlemail.com>
	<CAHf9xvZqQRBZraH4jGu+mRXQFk1aqKaCKMJno=ubypd2rYkicA@mail.gmail.com>
	<CAHf9xvaTESntqF_tpKL8CUJGig5vh+Dsh3rH136MpCGCGd1geg@mail.gmail.com>
	<CAB9VWqBco7__Gjby0j-JjOnd1h7Fh5ECq7BW4U1ubE=boQr0eg@mail.gmail.com>
Date: Wed, 25 Jul 2012 12:15:58 +0300
Message-ID: <CAHf9xvbuG6bF5sq7+JzfXpo1LvSDZ1T6P1mMRLKNA2A56sM0pg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] Btrfs-progs: add btrfs send/receive commands
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks!

So now:
A_PATH -> path -> full_path -> newpath
A_PATH_LINK  -> lnk -> full_link_path -> oldpath

while I viewed it the other way around.

I guess it's not important what is left/right, old/new :) as long as
it's consistent.

Alex.


On Tue, Jul 24, 2012 at 11:27 PM, Alexander Block
<ablock84@googlemail.com> wrote:
> On Thu, Jul 19, 2012 at 3:25 PM, Alex Lyakas
> <alex.bolshoy.btrfs@gmail.com> wrote:
>> +static int process_link(const char *path, const char *lnk, void *user)
>> +{
>> +       int ret;
>> +       struct btrfs_receive *r = user;
>> +       char *full_path = path_cat(r->full_subvol_path, path);
>> +
>> +       if (g_verbose >= 1)
>> +               fprintf(stderr, "link %s -> %s\n", path, lnk);
>> +
>> +       ret = link(lnk, full_path);
>> +       if (ret < 0) {
>> +               ret = -errno;
>> +               fprintf(stderr, "ERROR: link %s -> %s failed. %s\n", path,
>> +                               lnk, strerror(-ret));
>> +       }
>>
>> Actually it has to be:
>> char *full_link_path = path_cat(r->full_subvol_path, lnk);
>> ...
>> ret = link(full_path/*oldpath*/, full_link_path/*newpath*/);
>> ...
>> free(full_link_path);
>>
>> Thanks,
>> Alex.
>
> Actually, the pathes got mixed up in-kernel. You'll find a pushed fix
> in the kernel repo. I also pushed a fix to btrfs-progs containing the
> full_link_path. Thanks again :)
