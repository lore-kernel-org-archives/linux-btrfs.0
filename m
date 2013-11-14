Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58573 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3KNJZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 04:25:57 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so1572164wgg.28
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 01:25:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131113171337.GD18494@twin.jikos.cz>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
	<1360283822-23452-3-git-send-email-pomac@demius.net>
	<51AB691A.90605@dieterries.net>
	<20131113171337.GD18494@twin.jikos.cz>
Date: Thu, 14 Nov 2013 11:25:55 +0200
Message-ID: <CAOi1vP_jpK4mW0HcuJtZnCOaFmQPimzA+PAXQXPxg-m7M-3YNg@mail.gmail.com>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
From: Ilya Dryomov <idryomov@gmail.com>
To: David Sterba <dsterba@suse.cz>, Dieter Ries <lists@dieterries.net>,
        Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 13, 2013 at 7:13 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> On Sun, Jun 02, 2013 at 05:47:38PM +0200, Dieter Ries wrote:
>> For this to have any effect, 'h' must be added to getopt_long(), see
>> attached patch 1.
>>
>> However, this results in btrfsck -h and --help doing different things:
>>
>> --help prints the usage message to stdout and exits with exit(0).
>> -h prints the usage message to stderr and exits with exit(129).
>>
>> I made a patch to fix this, see attached patch 2.
>> What it doesn't fix though is, that -h/--help and -? don't do the same
>> thing. This is more complicated, as getop_long returns '?' for unknown
>> options.
>
> FYI, both patchess added to integration.

Hi David,

FWIW, I think none of the btrfs sub-commands treat -h as a help option.
(This is an artifact that was inherited from the the old btrfs-progs
utility.)  -h vs --help is actually consistent: -h results in a "btrfs
check: invalid option -- 'h'" message, and therefore exits with 129.
Since 'btrfs check -h' has clearly never worked we might want to keep
the status quo.

Thanks,

                Ilya
