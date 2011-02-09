From: "Helmut Hullen" <Hullen@t-online.de>
Subject: kernel panic (was: no space left on device)
Date: 09 Feb 2011 13:41:00 +0100
Message-ID: <BfYQ10yT1uB@helmut.hullen.de>
References: <4D5191F2.5080509@logtenberg.eu>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5191F2.5080509@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Erik,

Du meintest am 08.02.11:

>> Maybe that doesn't help now. I'm working with kernel 2.6.37 and
>> kernel 2.6.38-rc2, and I've got big problems.

> I had to install at least 2.6.37 to have a kernel with an advanced
> enough balance feature to actually reclaim the free space and report
> it correctly too.
> Still, I had so much kernel crashes during this balance operation
> that even after numerous retries I still hadn't once completed it (on
> a FS of merely 300GB). Fortunately Zheng Yan coded a patch, which I
> applied to 2.6.38-rc2, so that I could finally run - and finish - the
> balance operation.

Didn't help - sorry.

You can take a look to the last lines of my system after crashing into  
"kernel panic" with blinkenlights:

  http://helmut.hullen.de/btrfs/

The screenshots are hard to read - sorry.

Viele Gruesse!
Helmut
