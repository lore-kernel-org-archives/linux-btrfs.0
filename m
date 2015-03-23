Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51145 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbbCWNwO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 09:52:14 -0400
Date: Mon, 23 Mar 2015 09:47:34 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
To: =?iso-8859-1?q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
CC: <fdmanana@gmail.com>, =?iso-8859-1?q?Torbj=F8rn?= <lists@skagestad.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1427118454.5707.5@mail.thefacebook.com>
In-Reply-To: <55100CE5.5020602@itpas.no>
References: <550FEC73.9010507@skagestad.org>
	<CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>
	<55100CE5.5020602@itpas.no>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 8:53 AM, Torbjørn Skagestad 
<torbjorn@itpas.no> wrote:
> On 23. mars 2015 13:36, Filipe David Manana wrote:
>> On Mon, Mar 23, 2015 at 10:35 AM, Torbjørn <lists@skagestad.org> 
>> wrote:
>>> Hi,
>>> 
>>> After upgrading to 4.0.0-rc5 from 4.0.0-rc4 I see "Object already 
>>> exists"
>>> after reboot.
>>> The fs is forced read only.
>>> The error does not disappear after additional reboots.
>> If you go back to 4.0.0-rc4, does the error still happens?
> 
> As mentioned in the email to Chris:
> I will try to boot with 4.0.0-rc4 as soon as I get physical access, 
> and also revert ea526d18990018f224e5734748975bea1824545f.

In order to revert ea526d1899, you need to revert this one first:

commit dcdf7f6ddba006f3482ebee73dfa6b75aec5f07b
Author: Josef Bacik <jbacik@fb.com>
Date:   Mon Mar 2 16:37:31 2015 -0500

    Btrfs: prepare block group cache before writing


This second commit relies on the first one, things won't work right 
with only one gone.

-chris



