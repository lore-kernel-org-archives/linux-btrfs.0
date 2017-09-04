Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50343 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753699AbdIDPEv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 11:04:51 -0400
Date: Mon, 4 Sep 2017 17:04:47 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
Subject: Re: How to disable/revoke 'compression'?
Message-ID: <20170904150447.neyzhuunnslnaaqr@angband.pl>
References: <1504459921.8809.3.camel@cloud.haefemeier.eu>
 <20170903180636.ayrubvma7awbki6i@angband.pl>
 <e5ac8e29-ef97-0b9b-cdaa-cb928686d0d6@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <e5ac8e29-ef97-0b9b-cdaa-cb928686d0d6@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 03, 2017 at 08:30:59PM +0200, Hans van Kranenburg wrote:
> On 09/03/2017 08:06 PM, Adam Borowski wrote:
> > On Sun, Sep 03, 2017 at 07:32:01PM +0200, Cloud Admin wrote:
> >> Beside of it, is it possible to find out what the real and compressed size
> >> of a file, for example or the ratio?
> > 
> > Currently not.
> > 
> > I've once written a tool which does this, but 1. it's extremely slow, 2.
> > insane, 3. so insane a certain member of this list would kill me had I
> > distributed the tool.  Thus, I'd need to rewrite it first...
> 
> Heh, I wouldn't do that, since I need you to do my debian uploads. :D
> 
> But it would certainly help to be a bit less stubborn only wanting to
> code in the language that matches your country code. :O

It's even funnier that I prefer the C.UTF-8 locale over pl_PL.UTF-8, and
the C code works several orders of magnitude faster than the Perl+Python
version.

Ok, ok, in this case it's C++ but only because I couldn't be arsed to
implement a <set> the hard way.

> Or maybe I can help a bit, since it sounds like a nice one for the
> coding examples in the lib. ;]

The lib is a great help -- the ioctls are totally undocumented, your code is
a lot easier than RTFKing.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
