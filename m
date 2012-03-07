From: Fahrzin Hemmati <fahhem2@gmail.com>
Subject: Continuous Benchmarking
Date: Wed, 07 Mar 2012 00:57:28 -0800
Message-ID: <4F5722F8.3070505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've got a system up-and-running that can run arbitrary benchmarks in a 
VM with direct access to an SSD drive. I'd like to have a benchmark to 
run on a few different revisions of the btrfs code to get some data to 
test with, so if any btrfs devs or testers would like to help, please 
send a list of commands to run and what directory to run them from 
(inside the mount or outside can be inferred by /mnt/btrfs versus any 
other path).

I can benchmark both btrfs-progs and the kernel module separately, in 
case there are any btrfs-progs specific benchmarks people would like to run.

Best,
Fahrzin Hemmati
