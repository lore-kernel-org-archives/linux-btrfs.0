Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52490 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2FZS20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 14:28:26 -0400
Received: by ghrr11 with SMTP id r11so238648ghr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 11:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK43AWthZ5Y3Rjkp6EduXO17J7Paz7SHYj_qOUbpwHyVQ_JKRQ@mail.gmail.com>
References: <CAK43AWvAeKzhR2pdpTxMLA=66BK6ErLBCVzPB3Cyy7X+_EjZEA@mail.gmail.com>
	<CANZ96zW4BX4jXP+ZBj2380QJ3gB_yOWa6VgFn9gHBeDq1qc4Lg@mail.gmail.com>
	<CAK43AWthZ5Y3Rjkp6EduXO17J7Paz7SHYj_qOUbpwHyVQ_JKRQ@mail.gmail.com>
Date: Tue, 26 Jun 2012 11:28:23 -0700
Message-ID: <CAK43AWtSfiQ2qWjMEAWVagh0yPkpdpqmw69bvph9sMvdCgtbPg@mail.gmail.com>
Subject: Re: System Policy for Filenames
From: Aaron Peterson <myusualnickname@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Billy,

Thank you! I will look into FUSE.

Ultimately, I want my / to be mounted with these rules,  I will need a
boot loader to be able to handle it.

 I am wondering if filesystem software has hooks for AppArmor or
SELinux, or some other Linux Security Module would be appropriated to
add to filesystem code?

 Also, I tried joining a linux-fsdev mailing list, but it appears to be defunct.

Oh, This is interesting:
http://www.dwheeler.com/essays/fixing-unix-linux-filenames.html


 -AP
>
>
> On Tue, Jun 26, 2012 at 11:03 AM, Billy Crook <billycrook@gmail.com> wrote:
>> On Fri, Jun 22, 2012 at 4:06 AM, Aaron Peterson
>> <myusualnickname@gmail.com> wrote:
>>>  I would like to make a system policy that restricts the characters
>>> used in a filename, tests filenames by regular expression, and
>>> enforces case-insensitive-compatible exclusivity.
>>>
>>> Where should I start?
>>
>> I would find a filesystem-agnostic mailinglist.  None of these
>> objectives appear to have anything to do with btrfs.  There is
>> probably a generic fs layer that would be the appropriate place for
>> this, if not FUSE.
>>
>> You might also consider forcing users to access the fs through SAMBA
>> which has similar capabilities already.
