Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34549 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbK0WvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 17:51:04 -0500
Received: by ioir85 with SMTP id r85so125063623ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 14:51:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151127204305.GE24333@carfax.org.uk>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
	<20151127204305.GE24333@carfax.org.uk>
Date: Fri, 27 Nov 2015 15:51:03 -0700
Message-ID: <CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
Subject: Re: BTRFS: could not find root 8
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 1:43 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Nov 27, 2015 at 10:33:29PM +0200, Imran Geriskovan wrote:
>> After upgrading from systemd227 to 228
>> these messages began to show up during boot:
>>
>> [   24.652118] BTRFS: could not find root 8
>> [   24.664742] BTRFS: could not find root 8
>>
>> Are they important?
>
>    That's the quota tree. I don't know exactly what's happening, but
> possibly systemd is now enabling qgroups for its own purposes, and
> what you're seeing is simply the qgroups being enabled for the first
> time?

I'm seeing a feature in systemd 228, "systemd-tmpfiles learned two new
line types “q” and “Q” that operate like “v”, but also set up a basic
btrfs quota hierarchy when used on a btrfs file system with quota
enabled."
https://lukevizzicks.co.uk/systemd-228-system-and-service-manager-released/

But from github I'm not finding any indication that systemd enables
quota. This issue suggests that quota disabled is tolerated.
https://github.com/systemd/systemd/issues/1809

Questions:
a. Quotas seem to be sufficiently in-flux, and with two (?) deprecated
methods, and one new implementation that I don't think it's OK for
anything to enable it by default. Are there different opinions on
this?
b. For the OP, is it possible quotas was ever enabled on this file system?
c. How can we determine if quotas are enabled on Btrfs? I don't see a
command within btrfs-quota to determine quota status.



-- 
Chris Murphy
