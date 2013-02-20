Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46303 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab3BTUi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 15:38:59 -0500
Received: by mail-pb0-f45.google.com with SMTP id ro8so3081916pbb.18
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 12:38:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALJXSJq7Y4QyDpDY6g1A1o1=OoMRk+4p2L2vtAeU+-ATtbit-Q@mail.gmail.com>
References: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
	<512266F5.7000109@die-jansens.de>
	<CALJXSJpEVB6vESOQmpLfBkHYSqxU0quhByYGSJqgUR5SVY6Shw@mail.gmail.com>
	<20130220131123.GD9521@twin.jikos.cz>
	<CALJXSJq7Y4QyDpDY6g1A1o1=OoMRk+4p2L2vtAeU+-ATtbit-Q@mail.gmail.com>
Date: Wed, 20 Feb 2013 15:38:59 -0500
Message-ID: <CALJXSJprc0yVU9hBnRdmjMMEA9VJqYEeBW_k3R=VpJqa-yo_XA@mail.gmail.com>
Subject: Re: Kernel panic when scrub is used
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: dsterba@suse.cz, =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>,
        Arne Jansen <lists@die-jansens.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 1:42 PM, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
> On Wed, Feb 20, 2013 at 8:11 AM, David Sterba <dsterba@suse.cz> wrote:
>> Was the filesystem created with nodesize > 4k ?
>
> Yes; 64KB.

I just noticed I didn't mention that I have raid5/6 code merged in but
it never was used on the partition I scrubbed.
