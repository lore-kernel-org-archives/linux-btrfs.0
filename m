Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36854 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbcKHStd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 13:49:33 -0500
Received: by mail-yw0-f174.google.com with SMTP id l124so187361066ywb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Nov 2016 10:49:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1478572812.28957.4.camel@scientia.net>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz> <1478572812.28957.4.camel@scientia.net>
From: Mark Fasheh <mark@fasheh.com>
Date: Tue, 8 Nov 2016 10:49:31 -0800
Message-ID: <CAGe7X7=Paj=04_yKYUWSNJW=5T_XMs4DSUVLtcxjn=QXAUM-YQ@mail.gmail.com>
Subject: Re: Announcing btrfs-dedupe
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: dsterba@suse.cz, James Pharaoh <james@wellbehavedsoftware.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 7, 2016 at 6:40 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Mon, 2016-11-07 at 15:02 +0100, David Sterba wrote:
>> I think adding a whole-file dedup mode to duperemove would be better
>> (from user's POV) than writing a whole new tool
>
> What would IMO be really good from a user's POV was, if one of the
> tools, deemed to be the "best", would be added to the btrfs-progs and
> simply become "the official" one.

Yeah there's two problems, one being that the extent-same ioctl (and
duperemove) is cross-file system now so I. The other one James touches
on, which is that there's a non trivial amount of complexity in
duperemove so shoving it in btrfs progs just means we're going to have
parallel development streams solving some different problems.

That's not to say that every dedupe tool has to be complex - we have
xfs_io to run the ioctl and I don't think it'd be a bad idea if
btrfs-progs had a simple interface to it too.
   --Mark



-- 
"When the going gets weird, the weird turn pro."
Hunter S. Thompson
