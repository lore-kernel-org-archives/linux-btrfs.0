Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57136 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753689Ab3I0QWK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 12:22:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors, systemd-journal
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130927170737.5786c948@datenkhaos.de>
Date: Fri, 27 Sep 2013 10:22:04 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Message-Id: <B6716783-9558-4EA1-B713-1C0985D9B380@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com> <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com> <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com> <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com> <20130927170737.5786c948@datenkhaos.de>
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 27, 2013, at 9:07 AM, Johannes Hirte <johannes.hirte@datenkhaos.de> wrote:

> On Tue, 24 Sep 2013 22:34:20 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>> OK so I think I'm narrowing this down to just the systemd journal,
>> and it's not checksums that are corrupted, it's the journal itself.
> 
> I doubt it's systemd-dependent,

I did not intend to indicate only systemd journal can trigger this, but rather on my system those appear to be the only affected files. Anything that has the same write behavior as systemd-journald probably has the same problem.

> 
> on a fsck and scrub tells me that there are unfixable csum errors.

The scrub should cause messages to appear in dmesg that include a pathname to the affected files, which might hint at what has the same write behavior. Even though a fix has been sent to stable for the systemd journal triggered issue, you should still find out what's being corrupted in your situation in case the write behaviors are different yet are still triggering corruption.


Chris Murphy