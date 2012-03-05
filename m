From: Farz Hem <fahhem2@gmail.com>
Subject: Benchmark, Continuous Build/Integration
Date: Mon, 5 Mar 2012 15:15:15 -0800
Message-ID: <CAD8hrTMKpZg9Q1vE7L2RaUG-YnoET9tFJz1VqUupSMPL2tGMFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm interested in helping btrfs devs out by running a continuous
integration suite that builds different versions of btrfs from the
tree and runs some series of tests and times them all. I've got a
virtual machine with direct access to a 64GB SSD, though I could add
2+ 500GB spinning drives if there's enough interest.

I was hoping to get some input in terms of benchmarks to run, such as
Mason's compilebench, and outputs to record, such as Mason's
seekwatcher, from this list. What benchmarks do you run, and what
commands/options do you use to run them?

Best,
Fahrzin Hemmati
