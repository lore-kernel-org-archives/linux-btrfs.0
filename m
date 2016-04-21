Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:56921 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbcDUQxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 12:53:38 -0400
Subject: Re: btrfs-progs confusing message
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <5717E55A.5070400@gmail.com> <5718B359.4090207@gmail.com>
From: Konstantin Svist <fry.kun@gmail.com>
Message-ID: <57190590.9080609@gmail.com>
Date: Thu, 21 Apr 2016 09:53:36 -0700
MIME-Version: 1.0
In-Reply-To: <5718B359.4090207@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/21/2016 04:02 AM, Austin S. Hemmelgarn wrote:
> On 2016-04-20 16:23, Konstantin Svist wrote:
>> Pretty much all commands print out the usage message when no device is
>> specified:
>>
>> [root@host ~]# btrfs scrub start
>> btrfs scrub start: too few arguments
>> usage: btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata]
>> <path>|<device>
>> ...
>>
>> However, balance doesn't
>>
>> [root@host ~]# btrfs balance start
>> ERROR: can't access 'start': No such file or directory
>
> And this is an example of why backwards comparability can be a pain.
> The original balance command was 'btrfs filesystem balance', and had
> no start, stop, or similar sub-commands.  This got changed to the
> current incarnation when the support for filters was added.  For
> backwards compatibility reasons, we decided to still accept balance
> with no arguments other than the path as being the same as running
> 'btrfs balance start' on that path, and then made the old name an
> alias to the new one, with the restriction that you can't pass in
> filters through that interface.  What is happening here is that
> balance is trying to interpret start as a path, not a command, hence
> the message about not being able to access 'start'.
>

So since this is still detected as an error, why not print usage info at
this point?


