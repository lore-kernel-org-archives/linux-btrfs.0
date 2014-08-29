Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:47006 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaH2S5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 14:57:34 -0400
Received: by mail-la0-f45.google.com with SMTP id pn19so3231649lab.32
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Aug 2014 11:57:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140829185506.GA32185@infradead.org>
References: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
	<20140829145130.GA14038@infradead.org>
	<CAL3q7H7Qo0TiSUwZX+GbnsEpwEea6eFQJ_KPyM_O2PkTjKmVjA@mail.gmail.com>
	<20140829185506.GA32185@infradead.org>
Date: Fri, 29 Aug 2014 19:57:33 +0100
Message-ID: <CAL3q7H61+TyY9nJ4CqPbk+KrTA7vcYm_YtAaavDwPmOZJ8Yacw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix crash while a ranged msync() is ongoing
From: Filipe David Manana <fdmanana@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 29, 2014 at 7:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Aug 29, 2014 at 07:52:33PM +0100, Filipe David Manana wrote:
>> Point taken Christoph, this isn't specific to msync nor impossible to
>> happen before 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8.
>> I'll update the commit log to reflect that.
>>
>> Thanks for looking.
>
> Btw, if you have an easy enough reproducer it would be good to wire it
> up for xfstests.

See the bottom of the commit message, where I mention that it happens
(not very often) when running xfstests/generic/127 - more specifically
the calls to fsx with memory mapped IO.

thanks



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
