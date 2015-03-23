Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [85.19.192.2] ([85.19.192.2]:33392 "EHLO mail.itpas.no"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753124AbbCWNEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 09:04:54 -0400
Message-ID: <55100CE5.5020602@itpas.no>
Date: Mon, 23 Mar 2015 13:53:57 +0100
From: =?UTF-8?B?VG9yYmrDuHJuIFNrYWdlc3RhZA==?= <torbjorn@itpas.no>
MIME-Version: 1.0
To: fdmanana@gmail.com, =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
References: <550FEC73.9010507@skagestad.org> <CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>
In-Reply-To: <CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23. mars 2015 13:36, Filipe David Manana wrote:
> On Mon, Mar 23, 2015 at 10:35 AM, Torbjørn <lists@skagestad.org> wrote:
>> Hi,
>>
>> After upgrading to 4.0.0-rc5 from 4.0.0-rc4 I see "Object already exists"
>> after reboot.
>> The fs is forced read only.
>> The error does not disappear after additional reboots.
> If you go back to 4.0.0-rc4, does the error still happens?

As mentioned in the email to Chris:
I will try to boot with 4.0.0-rc4 as soon as I get physical access, and 
also revert ea526d18990018f224e5734748975bea1824545f.

Thanks.

--
Torbjørn
