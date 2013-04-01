Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50553 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab3DAWqQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 18:46:16 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so2396380oag.4
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 15:46:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <515A0C8A.9090708@oracle.com>
References: <CAKuK5J2kjRmoMCsAJv+tdarCkLZn0xykzfuhJ4kjxrR_5VKCGQ@mail.gmail.com>
 <515A0C8A.9090708@oracle.com>
From: Jon Nelson <jnelson@jamponi.net>
Date: Mon, 1 Apr 2013 17:45:56 -0500
Message-ID: <CAKuK5J02Gs3r2EaT4vDDSXh84iP9Hn_ZHS1zyyPcj5DHbf6mUQ@mail.gmail.com>
Subject: Re: device error stats resettable?
To: anand jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 1, 2013 at 5:39 PM, anand jain <anand.jain@oracle.com> wrote:
>
>>Is there a way to reset the device
>> error count?
>>
>
> there is -z, is it not what you are looking for ?
>
> ------
> # btrfs dev stat --help
> usage: btrfs device stats [-z] <path>|<device>
>
>     Show current device IO stats. -z to reset stats afterwards.

Aargh. Newer btrfs tool than I was using. Using the latest git
version, this works great, of course.
Thanks!

--
Jon
Software Blacksmith
