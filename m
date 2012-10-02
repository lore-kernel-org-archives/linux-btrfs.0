Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40573 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2JBAqh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2012 20:46:37 -0400
Received: by oagh16 with SMTP id h16so5736558oag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 17:46:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYTySBdZrZkbp_SBPUzr_he=a5FM+caSyADoUt2DiADdvw@mail.gmail.com>
References: <1349098002.208.YahooMailNeo@web31801.mail.mud.yahoo.com>
	<50699A40.2030603@yahoo.com.br>
	<CAG1y0sf=dN_p4BWHa5h=BjXnC7U+5D=01XEa1iFFzKdJJTFmyg@mail.gmail.com>
	<CAFvQSYTySBdZrZkbp_SBPUzr_he=a5FM+caSyADoUt2DiADdvw@mail.gmail.com>
Date: Tue, 2 Oct 2012 07:46:36 +0700
Message-ID: <CAG1y0scO3NSwL7Yf6ukb2NWfR9jFBnv7Yv1S=eHJn=4tc3SDBA@mail.gmail.com>
Subject: Re: Tunning - cache write (database)
From: "Fajar A. Nugraha" <list@fajar.net>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 2, 2012 at 3:16 AM, Clemens Eisserer <linuxhippy@gmail.com> wrote:
>> I suggest you start by reading
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18827.html
>>
>> After that, PROBABLY start your database by preloading libeatmydata to
>> disable fsync completely.
>
> Which will cure the sympthoms, not the issue itself - I remember the
> same advice was given for Reiser4 back then ;)
> Usually for non-toy use-cases data is too valueable to just disable fsync.

The OP DID say he doesn't really care about security, recovery, nor
integrity (or at least, it's not an obligatiion) :D

Other than trying latest -rc and using libeatmydata, I can't see what
else can be done to improve current db performance on btrfs. As the
list archive shows, zfs is currently MUCH more suitable for that.

-- 
Fajar
