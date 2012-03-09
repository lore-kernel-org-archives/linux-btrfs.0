From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 9 Mar 2012 10:15:02 +0100
Message-ID: <CADDYkjRW6QLk9sQdsgzQLUS6zLSFURpm=xSuhNArvqdBp=V_cg@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<4F59A69E.1040002@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F59A69E.1040002@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/9 Chris Samuel <chris@csamuel.org>:
> On 09/03/12 12:31, Liu Bo wrote:
>
>> So are these warnings based on the latest upstream of btrfs?
>
> Looks like it was 3.2.7, his oops said:
>
> Pid: 1488, comm: mips-wrs-linux- Tainted: G =A0 =A0 =A0 =A0W =A0 =A03=
=2E2.7 #2 HP

Yep, that's 3.2.7. Now I can't upgrade to latest upstream. As sson as
btrfs CI tests will finish I can go to latest upstream version.

-Jacek
