Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55647 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2JZDgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 23:36:50 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1630790pad.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 20:36:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1D6DC5A8-27E2-4470-B5D0-D1A7CC639825@colorremedies.com>
References: <50899151.1070503@inwind.it>
	<3BC0780A-C657-4195-BBAB-FFBDDBD989FB@colorremedies.com>
	<CAE5mzvi=czHnRcBUkyTn7NxzCRiZ-5GcZtZt8KGEX0tUiUz73g@mail.gmail.com>
	<1D6DC5A8-27E2-4470-B5D0-D1A7CC639825@colorremedies.com>
Date: Thu, 25 Oct 2012 21:36:49 -0600
Message-ID: <CAE5mzvicb1xXTEFKv2DtjxrnHUPi0TSn0d58aN+mBU7o80sRaA@mail.gmail.com>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 25, 2012 at 8:33 PM, Chris Murphy <lists@colorremedies.com> wrote:
> So what's the intended distinction between 'fi df' and 'fi show'? Because for months using btrfs I'd constantly be confused which command was going to show me what information I wanted, and that tells me there should be some better distinction between the commands.

Or the distinction should be removed, which is what this patch effectively does.
