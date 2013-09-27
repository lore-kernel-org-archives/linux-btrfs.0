Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39336 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3I0OaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 10:30:12 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so994761bkj.33
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 07:30:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130927142535.GB28147@carfax.org.uk>
References: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com>
 <20130927142535.GB28147@carfax.org.uk>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 27 Sep 2013 16:29:49 +0200
Message-ID: <CAG-2HqUVWiJ_Z-7Q1wjXnETYKaOekm9TN2bm3_BFTG48nrNvKw@mail.gmail.com>
Subject: Re: csum questions
To: Hugo Mills <hugo@carfax.org.uk>, Tom Gundersen <teg@jklm.no>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 4:25 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Sep 27, 2013 at 04:22:16PM +0200, Tom Gundersen wrote:
>> 1) What happens to the file. Will btrfs just leave it alone, or will
>> it be deleted from disk (I seem to remember reading this somewhere,
>> just want to confirm)?
>
>    It's left there.

Good to know :-)

>> 2) How may I tell btrfs to ignore all csums and just assume they are
>> all correct? The reason for wanting this is in case the csum is
>> garbled and the file is intact, or the csum is correct and the file is
>> only partially garbled, but may still contain useful data.
>
>    You can't, right now. There's discussion on IRC about this very
> point right now. :)

/me joins

Thanks.

Tom
