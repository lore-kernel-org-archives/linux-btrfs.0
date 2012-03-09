From: Chris Samuel <chris@csamuel.org>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 09 Mar 2012 17:43:42 +1100
Message-ID: <4F59A69E.1040002@csamuel.org>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>	<20120308155211.GF4334@twin.jikos.cz> <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com> <4F595D6D.6080809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F595D6D.6080809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/12 12:31, Liu Bo wrote:

> So are these warnings based on the latest upstream of btrfs?

Looks like it was 3.2.7, his oops said:

Pid: 1488, comm: mips-wrs-linux- Tainted: G        W    3.2.7 #2 HP

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
