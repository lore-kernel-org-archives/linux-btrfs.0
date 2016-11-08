Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:36039 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbcKHS76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 13:59:58 -0500
Received: by mail-yw0-f175.google.com with SMTP id l124so187812262ywb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Nov 2016 10:59:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161108021722.GA16801@birch.djwong.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz> <CAGe7X7n=xkveD4TS2cyfXx5-hydOCHTh=tjDK54h8HWpnK5NqQ@mail.gmail.com>
 <20161107205409.GA20325@angband.pl> <20161108021722.GA16801@birch.djwong.org>
From: Mark Fasheh <mark@fasheh.com>
Date: Tue, 8 Nov 2016 10:59:56 -0800
Message-ID: <CAGe7X7m-rPmGxk3DXuo6Vo5qAQwRhNFEKyRZzYxP2iyy1mGrSw@mail.gmail.com>
Subject: Re: Announcing btrfs-dedupe
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Adam Borowski <kilobyte@angband.pl>, dsterba@suse.cz,
        James Pharaoh <james@wellbehavedsoftware.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 7, 2016 at 6:17 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, Nov 07, 2016 at 09:54:09PM +0100, Adam Borowski wrote:
>> Mark has already included XFS in documentation of duperemove, all that looks
>> amiss is btrfs-extent-same having an obsolete name.  But then, I never did
>> any non-superficial tests on XFS, beyond "seems to work".

I'd actually be ok dropping btrfs-extent-same completely at this point
but I'm concerned that it would leave some users behind.


> /me wonders if ocfs2 will ever catch up to the reflink/dedupe party. ;)

Hey, Ocfs2 started the reflink party! But yeah it's fallen behind
since then with respect to cow and dedupe. More importantly though I'd
like to see some extra extent tracking in there like XFS did with the
reflink b+tree.
   --Mark

-- 
"When the going gets weird, the weird turn pro."
Hunter S. Thompson
