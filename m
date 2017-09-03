Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:50594 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdICSiC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Sep 2017 14:38:02 -0400
Subject: Re: How to disable/revoke 'compression'?
To: Adam Borowski <kilobyte@angband.pl>,
        Cloud Admin <admin@cloud.haefemeier.eu>
Cc: linux-btrfs@vger.kernel.org
References: <1504459921.8809.3.camel@cloud.haefemeier.eu>
 <20170903180636.ayrubvma7awbki6i@angband.pl>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e5ac8e29-ef97-0b9b-cdaa-cb928686d0d6@mendix.com>
Date: Sun, 3 Sep 2017 20:30:59 +0200
MIME-Version: 1.0
In-Reply-To: <20170903180636.ayrubvma7awbki6i@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/2017 08:06 PM, Adam Borowski wrote:
> On Sun, Sep 03, 2017 at 07:32:01PM +0200, Cloud Admin wrote:
>> Hi,
>> I used the mount option 'compression' on some mounted sub volumes. How
>> can I revoke the compression? Means to delete the option and get all
>> data uncompressed on this volume.
>> Is it enough to remount the sub volume without this option? Or is it
>> necessary to do some addional step (balancing?) to get all stored data
>> uncompressed.
> 
> If you set it via mount option, removing the option is enough to disable
> compression for _new_ files.  Other ways are chattr +c and btrfs-property,
> but if you haven't heard about those you almost surely don't have such
> attributes set.
> 
> After remounting, you may uncompress existing files.  Balancing won't do
> this as it moves extents around without looking inside; defrag on the other
> hand rewrites extents thus as a side effect it applies new [non]compression
> settings.  Thus: ｢btrfs fi defrag -r /path/to/filesystem｣.
> 
>> Beside of it, is it possible to find out what the real and compressed size
>> of a file, for example or the ratio?
> 
> Currently not.
> 
> I've once written a tool which does this, but 1. it's extremely slow, 2.
> insane, 3. so insane a certain member of this list would kill me had I
> distributed the tool.  Thus, I'd need to rewrite it first...

Heh, I wouldn't do that, since I need you to do my debian uploads. :D

But it would certainly help to be a bit less stubborn only wanting to
code in the language that matches your country code. :O

Or maybe I can help a bit, since it sounds like a nice one for the
coding examples in the lib. ;] Days are getting shorter again, so the
amount of indoor coding activity will hopefully increase a bit again soon.

-- 
Hans van Kranenburg
