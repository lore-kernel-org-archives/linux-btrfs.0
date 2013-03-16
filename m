Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38069 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3CPMoT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 08:44:19 -0400
Date: Sat, 16 Mar 2013 05:44:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: cwillu <cwillu@cwillu.com>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: multiple btrfsck runs
Message-ID: <20130316124415.GL24591@merlins.org>
References: <201303162302.14746.russell@coker.com.au>
 <CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 16, 2013 at 06:24:47AM -0600, cwillu wrote:
> On Sat, Mar 16, 2013 at 6:02 AM, Russell Coker <russell@coker.com.au> wrote:
> > Is it expected that running btrfsck more than once will keep reporting errors?
> 
> Without options, btrfsck does not write to the disk.

Aaaaah, that explains why I never got it to work the day I wanted to try
it.
I should note that waht you're saying is neither documented in the man
page, nor in https://btrfs.wiki.kernel.org/index.php/Btrfsck

For that matter, the wiki actually states there are no options.

Is that mostly intentional so that whoever isn't reading the source
doesn't really run the tool because it's not ready?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
