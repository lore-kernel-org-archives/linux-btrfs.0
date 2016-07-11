Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35862 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcGKOIB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 10:08:01 -0400
Received: by mail-wm0-f65.google.com with SMTP id x83so14718709wma.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 07:08:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160617171807.GI4915@twin.jikos.cz>
References: <20160614225541.18140-1-benedikt.morbach@googlemail.com>
 <1465945606.18810.1.camel@googlemail.com> <20160617171807.GI4915@twin.jikos.cz>
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
Date: Mon, 11 Jul 2016 16:07:25 +0200
Message-ID: <CAC-H7H=_SaLg_w0uuXpG+yfxjo2zkumzhh+DQ34AqGfQj4rOXw@mail.gmail.com>
Subject: Re: [PATCH] receive: strip root subvol path during process_clone
To: dsterba@suse.cz, Benedikt Morbach <benedikt.morbach@googlemail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Fri, Jun 17, 2016 at 7:18 PM, David Sterba <dsterba@suse.cz> wrote:
> thanks for the fix. The mail thread holds enough information to
> reproduce the issue, I'll get to that on Monday. I'm not sure about the
> use of strstr to match the subvolume name so I want to write the tests
> first and craft some paths to see how it works.

any update on this? I've been running this patch for a few weeks now
with my hourly backups.
I could also take a stab at writing a test case but I think I'd need
some pointers for that. ;-)

I took a look at the send/receive patches that Filipe sent earlier and
afaict this isn't fixed in those.
