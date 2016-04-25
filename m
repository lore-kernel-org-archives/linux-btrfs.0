Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:32788 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbcDYLY3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 07:24:29 -0400
Received: by mail-wm0-f50.google.com with SMTP id 127so22412992wmz.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 04:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160425111249.GB23222@twin.jikos.cz>
References: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
	<20160425111249.GB23222@twin.jikos.cz>
Date: Mon, 25 Apr 2016 07:24:27 -0400
Message-ID: <CAD=QJKgRSEQwMyLiBgrWWiD+9oUWSP=r9jEOFXiHhubq=4w6wQ@mail.gmail.com>
Subject: Re: primary location of btrfs-progs changelog: The wiki?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: dsterba@suse.cz, Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 April 2016 at 07:12, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Apr 22, 2016 at 08:41:36PM -0400, Nicholas D Steeves wrote:
>> I'm just wondering where the primary location of the btrfs-progs
>> changelog is located
>
> At the moment it's the release announcement in this mailinglist, that
> gets copied to the wiki with some formatting adjustments. I'm willing to
> copy the announcement text to a file in git (and will do for the next
> release). But at the moment I won't add all the past changelogs so if
> anybody wants to do that I'l appreciate that.

I'd be happy to.  Are you looking for something like:

curl https://btrfs.wiki.kernel.org/index.php/Changelog | html2text |
sed '0,/(announcement)/d;/By version (linux kernel)/Q' | gzip -9 >
changelog

With some formatting adjustments?

Cheers,
Nicholas
