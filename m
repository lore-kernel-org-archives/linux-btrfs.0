Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:43605 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaDXWD0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 18:03:26 -0400
Received: by mail-la0-f54.google.com with SMTP id e16so2235348lan.27
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 15:03:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535912E5.7080106@gmail.com>
References: <20140424011834.GN26949@merlins.org>
	<20140424011952.GO26949@merlins.org>
	<535912E5.7080106@gmail.com>
Date: Thu, 24 Apr 2014 15:03:24 -0700
Message-ID: <CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com>
Subject: Re: Which companies are using Btrfs in production?
From: Justin Maggard <jmaggard10@gmail.com>
To: Daniel Lee <longinus00@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 6:34 AM, Daniel Lee <longinus00@gmail.com> wrote:
> On 04/23/2014 06:19 PM, Marc MERLIN wrote:
>> Oh while we're at it, are there companies that can say they are using btrfs
>> in production?
>>
>> Marc
> Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
> They apparently use Oracle's linux distro so I assume they're relying on
> them to do most of the heavy lifting as far as support BTRFS and
> backporting goes since they're still on 3.0! They also have raid5/6
> support so they are probably running BTRFS on top of md.
>

Yes, and any contributions you see coming from me so far, come from
NETGEAR.  I've been using my gmail account because I can't make our
corporate email server leave off the nasty confidentiality legal
disclaimer.

We don't use Oracle's distro.  Our OS is a Debian derivative, but we
have pulled in lots of changes from Oracle UEK and the SUSE SLE11-SP3
kernel tree.  And we do indeed run atop MD.

-Justin
