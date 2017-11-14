Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50952 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753971AbdKNOo2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 09:44:28 -0500
Date: Tue, 14 Nov 2017 19:44:26 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: A partially failing disk in raid0 needs replacement
Message-ID: <20171114194426.07ac4e85@natsu>
In-Reply-To: <CAFTHvW9=ojuQW0GWRLdy2g4j7DSzT13-=ODrjhjWAq3YMEiszg@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
        <20171114174856.12ae346f@natsu>
        <CAFTHvW9=ojuQW0GWRLdy2g4j7DSzT13-=ODrjhjWAq3YMEiszg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Nov 2017 15:09:52 +0100
Klaus Agnoletti <klaus@agnoletti.dk> wrote:

> Hi Roman
> 
> I almost understand :-) - however, I need a bit more information:
> 
> How do I copy the image file to the 6TB without screwing the existing
> btrfs up when the fs is not mounted? Should I remove it from the raid
> again?

Oh, you already added it to your FS, that's so unfortunate. For my scenario I
assumed have a spare 6TB (or any 2TB+) disk you can use as temporary space.

You could try removing it, but with one of the existing member drives
malfunctioning, I wonder if trying any operation on that FS will cause further
damage. For example if you remove the 6TB one, how do you prevent Btrfs from
using the bad 2TB drive as destination to relocate data from the 6TB drive. Or
use it for one of the metadata mirrors, which will fail to write properly,
leading into transid failures later, etc.

-- 
With respect,
Roman
