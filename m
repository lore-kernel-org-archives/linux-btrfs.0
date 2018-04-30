Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:40405 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753508AbeD3Q4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 12:56:36 -0400
Received: by mail-vk0-f46.google.com with SMTP id x204-v6so5494642vkd.7
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:56:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c552d9cd-5ce9-b55c-747e-3af28ec161b8@suse.com>
References: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
 <c552d9cd-5ce9-b55c-747e-3af28ec161b8@suse.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Mon, 30 Apr 2018 11:56:35 -0500
Message-ID: <CA+EzBbB2HkAbpQhKPhm_h2qE3AqeUFvC0+EYsk=AviyfnzLu5Q@mail.gmail.com>
Subject: Re: Strange behavior (possible bugs) in btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Vijay Chidambaram <vvijay03@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Soujanya Ponnapalli <soujanyap95@gmail.com>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On Mon, Apr 30, 2018 at 11:51 AM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 4/30/18 12:04 PM, Vijay Chidambaram wrote:
>> Hi,
>>
>> We found two more cases where the btrfs behavior is a little strange.
>> In one case, an fsync-ed file goes missing after a crash. In the
>> other, a renamed file shows up in both directories after a crash.
>
> Hi Vijay -
>
> What kernel version did you observe these with?  These seem like bugs
> Filipe has already fixed.
>
> -Jeff
>

These bugs were observed on Kernel 4.16.0-041600-generic.

Thanks,
Jayashree
