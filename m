Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:35912
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbIVO5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:57:38 -0400
Received: from tux.wizards.de (p4FF58F87.dip0.t-ipconnect.de [79.245.143.135])
	by mail02.iobjects.de (Postfix) with ESMTPSA id B8C4A4160166
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 16:57:36 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 2F42D11C0032
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 16:57:35 +0200 (CEST)
Subject: Re: problem with long running btrfs mount operation
References: <20150922133813.GA14395@sfserver>
 <56015D3F.8020406@googlemail.com>
 <CABR0jERXQ9ydE+KAeQBrW5F0DzraePnAyz8m-uVStUCbeFt4WQ@mail.gmail.com>
 <20150922144312.GB14395@sfserver>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56016C5F.6010406@googlemail.com>
Date: Tue, 22 Sep 2015 16:57:35 +0200
MIME-Version: 1.0
In-Reply-To: <20150922144312.GB14395@sfserver>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/15 16:43, S. Fricke wrote:
>> On Tue, Sep 22, 2015 at 9:53 AM, Holger Hoffstätte
>> <holger.hoffstaette@googlemail.com> wrote:
>>> On 09/22/15 15:38, S. Fricke wrote:
>>>> I have a problem with one of my btrfs hdds. If I mount it, it needs more than
>>>> 135 minutes for this operation. After the mounting it works normaly. This is
>>>> reproducible only with this hdd.
>>>>
>>>> Maybe someone has a clue what is going wrong here.
>>>
>>> On remount it tries to continue a previously started balance, which fails with
>>> an error (as can be seen at the end of your log). You should:
>>>
>>> a) immediately stop what you're doing on that fs and unmount it
>>> b) get btrfs-progs-4.2.1 (not 4.2) and see what it says
> 
> What should it say to me? I have to send a command? Should I try to mount the
> device after I have unmount it? BTW: Is btrfs-progs needed for mounting?

I should have been more clear and say "run btrfs check", which I originally
intended to write but then somehow didn't. Sorry. :-)

btrfs-progs is not needed for mounting, only for administrative commands.

-h

