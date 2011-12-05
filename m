From: Peeters Simon <peeters.simon@gmail.com>
Subject: CPU usage in 3.2 RC4
Date: Mon, 5 Dec 2011 19:15:20 +0100
Message-ID: <CAKyAS7uM=Vba0PcgngNAsN=WLJxPufV4B35UjfmgEy4KajDa9g@mail.gmail.com>
References: <CAKyAS7tOr9QDYQxZpniuwm9eV3CaJW8VpQCksOwCU=drCJGy2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKyAS7tOr9QDYQxZpniuwm9eV3CaJW8VpQCksOwCU=drCJGy2w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

hi everybody

i recently switched from a 3.1 kernel to 3.2rc4 from fedora rawhide.
since i switched i am having serious performance isues, mainly due to
my limmited cpu (1.6Ghz attom single core)
when i boot in 3.1 my bootup is mainly I/O limited (according to bootch=
art)
when i boot in 3.2 my bootup is compleetly CPU limited and takes a lot =
more time

also file actions (like tar -xf linux-3.1.tar takes) are a cpu hogg,
according to top most of the cpu usage is in kernel space, and i see
different btrfs threads at the top

time tar -xf linux-3.1.tar.bz2
real=A0=A0=A0 11m10.037s
user=A0=A0=A0 1m26.861s
sys=A0=A0=A0 5m26.738s

cpu usage
8%user,
82%sys,

flush-btrfs-5 50%
tar 45%
btrfs-endio-write 20%
btrfs-transaction 15%

it would be nice if somebody could look into this, and hopefully get
it fixed in 3.2 final (i am not a kernel or btrfs guru, so i don't
know where to start looking for the problem)

greetings

Simon Peeters
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
