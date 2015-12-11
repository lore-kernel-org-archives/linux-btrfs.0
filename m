Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:36504 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbLKRyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 12:54:50 -0500
Received: by qgcc31 with SMTP id c31so203268542qgc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 09:54:49 -0800 (PST)
Subject: Re: new oops in 4.4.0-rc4
To: Chris Mason <clm@fb.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <dsj@fb.com>, linux-kernel@vger.kernel.org,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <5669AA01.2000300@jons.org>
 <20151211153559.GD11257@ret.masoncoding.com>
From: Jon Christopherson <jon@jons.org>
Message-ID: <566B0DE7.3030406@jons.org>
Date: Fri, 11 Dec 2015 11:54:47 -0600
MIME-Version: 1.0
In-Reply-To: <20151211153559.GD11257@ret.masoncoding.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2015 09:35 AM, Chris Mason wrote:
> On Thu, Dec 10, 2015 at 10:36:17AM -0600, Jon Christopherson wrote:

<snip>

>
> Dave Jones sent in a report about this with trinity too, I'm digging in
> today.  Since you can trigger this reliably, what was the last
> known-good kernel for you?
>
> -chris
>

Hello,

My last known good kernel was from Dec 5 04:00 CST:

Linux version 4.4.0-120-generic (root@enigma.jons.org) (gcc version 
5.2.1 20151124 (Ubuntu 5.2.1-1ubuntu1~14.04) ) #201512050400 SMP Sat Dec 
5 03:54:25 CST 2015

I will check over the commits from then till now as well.


Regards,

Jon Christopherson

