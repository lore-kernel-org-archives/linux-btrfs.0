Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37671 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbbIWFmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 01:42:19 -0400
Received: by wicfx3 with SMTP id fx3so52743357wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 22:42:17 -0700 (PDT)
Date: Wed, 23 Sep 2015 07:42:16 +0200
From: "S. Fricke" <silvio.fricke@gmail.com>
To: Richard Michael <rmichael@edgeofthenet.org>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: problem with long running btrfs mount operation
Message-ID: <20150923054216.GD14395@sfserver>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56016C5F.6010406@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


>>> On Tue, Sep 22, 2015 at 9:53 AM, Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:
>>>> On 09/22/15 15:38, S. Fricke wrote:
>>>>> I have a problem with one of my btrfs hdds. If I mount it, it needs more than
>>>>> 135 minutes for this operation. After the mounting it works normaly. This is
>>>>> reproducible only with this hdd.
>>>>>
>>>>> Maybe someone has a clue what is going wrong here.
>>>>
>>>> On remount it tries to continue a previously started balance, which fails with
>>>> an error (as can be seen at the end of your log). You should:
>>>>
>>>> a) immediately stop what you're doing on that fs and unmount it
>>>> b) get btrfs-progs-4.2.1 (not 4.2) and see what it says
>> 
>> What should it say to me? I have to send a command? Should I try to mount the
>> device after I have unmount it? BTW: Is btrfs-progs needed for mounting?
> 
> I should have been more clear and say "run btrfs check", which I originally
> intended to write but then somehow didn't. Sorry. :-)

the 'btrfs check' has took some time. Here is the printout. Some advises for me?


Best Regards,
Silvio

% sudo btrfs check /dev/sda1
Checking filesystem on /dev/sda1
UUID: 4db27f9b-d8fe-4341-985a-4ce55ea9fd25
checking extents
bad metadata [1634295414784, 1634295418880) crossing stripe boundary
bad metadata [1634394767360, 1634394771456) crossing stripe boundary
bad metadata [1634691842048, 1634691846144) crossing stripe boundary
bad metadata [1634770485248, 1634770489344) crossing stripe boundary
bad metadata [1634798141440, 1634798145536) crossing stripe boundary
[... many lines cutted ...]
bad metadata [1908346978304, 1908346982400) crossing stripe boundary
bad metadata [1908597653504, 1908597657600) crossing stripe boundary
bad metadata [1908663386112, 1908663390208) crossing stripe boundary
bad metadata [1908664041472, 1908664045568) crossing stripe boundary
bad metadata [1908832010240, 1908832014336) crossing stripe boundary
bad metadata [1908848984064, 1908848988160) crossing stripe boundary
ref mismatch on [1908883419136 4096] extent item 1, found 0
Backref 1908883419136 parent 1890809671680 not referenced back 0x4fadc740
Incorrect global backref count on 1908883419136 found 1 wanted 0
backpointer mismatch on [1908883419136 4096]
owner ref check failed [1908883419136 4096]
bad metadata [1908961640448, 1908961644544) crossing stripe boundary
bad metadata [1909004566528, 1909004570624) crossing stripe boundary
bad metadata [1909015052288, 1909015056384) crossing stripe boundary
bad metadata [1909015183360, 1909015187456) crossing stripe boundary
Backref 1909016203264 parent 1890809671680 not referenced back 0x4fc37690
Backref 1909016203264 parent 5105 root 5105 not found in extent tree
Incorrect global backref count on 1909016203264 found 3 wanted 2
backpointer mismatch on [1909016203264 4096]
bad metadata [1909017804800, 1909017808896) crossing stripe boundary
bad metadata [1909144289280, 1909144293376) crossing stripe boundary
bad metadata [1909164539904, 1909164544000) crossing stripe boundary
bad metadata [1909445033984, 1909445038080) crossing stripe boundary
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 716978874897 bytes used err is 0
total csum bytes: 662660776
total tree bytes: 39097315328
total fs tree bytes: 36827172864
total extent tree bytes: 1529536512
btree space waste bytes: 11582963983
file data blocks allocated: 1258206822400
 referenced 1158920425472
btrfs-progs v4.2.1


-- 
-- S. Fricke ---------------------------------------- silvio@port1024.net --
   Diplom-Informatiker (FH)
   Linux-Entwicklung             JABBER: silvio@conversation.port1024.net   
----------------------------------------------------------------------------
