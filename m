Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63365 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaHIQGi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 12:06:38 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so8562496pdj.12
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 09:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev>
	<20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
Date: Sat, 9 Aug 2014 11:06:37 -0500
Message-ID: <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
To: Andy Smith <andy@strugglers.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Re-sending to list.

On Sat, Aug 9, 2014 at 9:58 AM, Jose Ildefonso Camargo Tolosa
<ildefonso.camargo@gmail.com> wrote:
> On Sat, Aug 9, 2014 at 9:32 AM, Andy Smith <andy@strugglers.net> wrote:
>> Hello,
>>
>> On Sat, Aug 09, 2014 at 01:38:34PM +1000, Russell Coker wrote:
>>> On Fri, 8 Aug 2014 16:35:29 Jose Ildefonso Camargo Tolosa wrote:
>>> > Then, after reading here and there, decided to try to use a newer
>>> > kernel, tried 3.15.8.  Well, it is still mounting after ~16 hours, and
>>> > I got messages like these at first:
>>>
>>> I recommend trying a 3.14 kernel.  I had ongoing problems with kernels before
>>> 3.14 which included infinite loops in kernel space.  Based on reports on this
>>> list I haven't been inclined to test 3.15 kernels.  But 3.14 has been working
>>> well for me on many systems.
>>
>> I'm in a similar position with a filesystem that won't mount except
>> read-only, but am already on 3.14 and am also wondering whether to
>> try a 3.16 kernel.
>>
>>     https://bugzilla.kernel.org/show_bug.cgi?id=81981
>>
>> Jose, maybe you could try -oro in the hope of at least getting back
>> to a read-only mount?
>
> Will try 3.14, ro would be "good enough" for me, provided that I can
> resize the filesystem, if I can do that, I can create a new one, and
> copy all data (hopefully faster than moving ~11TB of data through the
> network).

Or maybe 3.16? sigh.... I have them both ready, but I am not sure
which one to try.  My fear is that if I go to 3.16 (still in
development), would I be able to go back to, say, 3.14 and work with
the filesystem there?  According to documents, disk format is "stable"
now.

What do you say? 3.14 or 3.16 for my next attempt (I have just today,
if I can't get this FS back to life today, I will blow it and start
over, with the ~1.5 weeks copy period ahead of me).

-- 
Ildefonso Camargo
Command Prompt, Inc. - http://www.commandprompt.com/
PostgreSQL Support, Training, Professional Services and Development
High Availability, Oracle Conversion, Postgres-XC
@cmdpromptinc - 509-416-6579
