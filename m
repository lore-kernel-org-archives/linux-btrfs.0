Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37136 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbeDWSjv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 14:39:51 -0400
Received: by mail-it0-f51.google.com with SMTP id 71-v6so11954468ith.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 11:39:51 -0700 (PDT)
Subject: Re: libbrtfsutil questions
To: waxhead@dirtcellar.net, linux-btrfs@vger.kernel.org
References: <003ad066-7544-e452-90ac-b2cad9cc1d06@dirtcellar.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <acb2d254-d5d0-4e2c-f661-ab22baeafa39@gmail.com>
Date: Mon, 23 Apr 2018 14:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <003ad066-7544-e452-90ac-b2cad9cc1d06@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-23 14:25, waxhead wrote:
> Howdy!
> 
> I am pondering writing a little C program that use libmicrohttpd and 
> libbtrfsutil to display some very basic (overview) details about BTRFS.
> 
> I was hoping to display the same information that'btrfs fi sh /mnt' and 
> 'btrfs fi us -T /mnt' do, but somewhat combined. Since I recently just 
> figured out how easy it was to do svg graphics I was hoping to try to 
> visualize things a bit.
> 
> What I was hoping to achieve is:
> - show all filesystems
> - ..show all devices in a filesystem (and mark missing devices clearly)
> - ....show usage and/or allocation for each device
> - ....possibly display chunks as blocks (like old defrag programs) where 
> the brightness indicate how utilied a (meta)data chunk is.
> - ....possibly mark devices with errors ( 'btrfs de st /mnt' ).
> 
> The problem is ... I looked at libbtrfsutil and it appears that there is 
> mostly sync + subvolume/snapshot stuff in there. >
> So my question is: Is libbtrfsutil the right choice and intended to at 
> some point (in the future?) supply me with the data I need for these 
> things or should I look elsewhere?
I believe that the intent is for libbtrfsutil to cover pretty much 
everything (AIUI, that's supposed to become the public API for BTRFS, 
with the CLI tools just being wrappers for that).  However, as you've 
found out, it's not really there yet.

If you've got some experience with Python and don't mind putting a bit 
more work in learning how things work at a low level in BTRFS, the 
Python interface maintained by Hans van Kranenburg and found at [1] may 
be of some interest.  I would imagine it shouldn't be much more 
difficult to wire the Python http.server module up to that than it would 
be to wire libmicrohttpd up to a C library, and it would give the 
advantage that you could use a nice templating language like Jinja2 to 
format everything.
> 
> PS! This a completely private project for my own egoistic reasons. 
> However if it turns out to be useful and the code is not too 
> embarrassing I am happy put the code into public domain ... if it ever 
> gets written.... :S
For what it's worth, I think the idea is great.  Especially if it could 
be made to return the data in a JSON format, as that would then make it 
trivial to use for integrating most existing system monitoring 
infrastructure with BTRFS.


[1] https://github.com/knorrie/python-btrfs
