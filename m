Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:43629 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbeFGHTk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 03:19:40 -0400
Received: by mail-ot0-f194.google.com with SMTP id i19-v6so10346496otk.10
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 00:19:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d2875ce4-1d61-1298-c7d7-a522ca04d43a@cn.fujitsu.com>
References: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
 <d2875ce4-1d61-1298-c7d7-a522ca04d43a@cn.fujitsu.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 7 Jun 2018 03:19:39 -0400
Message-ID: <CA+X5Wn4nhGQDAs-kgGraUpT8R6W6w06Gp2e4QnDvNfHvZZCCjQ@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot > items
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 7, 2018 at 12:20 AM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:
> On 06/07/2018 11:33 AM, james harvey wrote:
>> Using btrfs-progs v4.16:
>>
>> No extent found at range [10955980800,10955984896)
>>
>> But, this extent exists.  btrfs-debug-tree shows:
> Make sense. IMP the commit message is too long to read.
> Code wise is almost fine. Some nitpicks are below.

Thanks for response.  I'll try to work on that.

>> +       if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
>> +               ret = btrfs_next_leaf(fs_info->extent_root, path);
>> +               if (ret != 0) {
>> +                       ret = -1;
>
> btrfs_next_leaf() may return -EIO, so keep the negative return code is
> prefered.
> btrfs_next_leaf may return > 0, here I'd like to set ret=-ENOENT.
> You can refer callers of btrfs_next_leaf() how to handle the return codes.

Fixed in v2.

>>                 else
>> -                       ret = btrfs_next_item(fs_info->extent_root, path);
>> +                       ret =
> Nit:
> Misclick here?

Missed semicolon being 81st character, fixed in v2.
