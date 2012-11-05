Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63558 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2KEQZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 11:25:38 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so4031217pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2012 08:25:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121105160649.GM3102@twin.jikos.cz>
References: <loom.20121031T131532-168@post.gmane.org>
	<20121105160649.GM3102@twin.jikos.cz>
Date: Mon, 5 Nov 2012 10:25:38 -0600
Message-ID: <CAE5mzvjKaXki3fPXOMVGt_h6XO+a--J_ADU2AYwz3eCWUgp6XA@mail.gmail.com>
Subject: Re: (late) REQUEST: Default mkfs.btrfs block size
From: cwillu <cwillu@cwillu.com>
To: dave@jikos.cz, Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 5, 2012 at 10:06 AM, David Sterba <dave@jikos.cz> wrote:
> On Wed, Oct 31, 2012 at 12:20:39PM +0000, Alex wrote:
>> As one 'stuck' with 4k leaves on my main machine for the moment, can I request
>> the btrfs-progs v0.20 defaults to more efficient decent block sizes before
>> release. Most distro install programs for the moment don't give access to the
>> options at install time and there seems to be is a significant advantage to 16k
>> or 32k
>
> IMHO this should be fixed inside the installer, changing defaults for a
> core utility will affect everybody. 4k is the most tested option and
> thus can be considered "safe for everybody".
>
> The installer may let you to enter a shell and create the filesystem by
> hand, then point it to use it for installation.

If we know a better setting, we should default to it.  Punting the
decision to the distro just means I'll spend the next 3 years telling
people "yeah, distro X doesn't set it to the recommended setting
(which isn't the mkfs default), and there's no way to change it
without wiping and reinstalling using manual partitioning blah blah
blah."
