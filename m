From: David Nicol <davidnicol@gmail.com>
Subject: Re: Swap file on btrfs fails ("swapfile has holes")
Date: Tue, 23 Aug 2011 10:58:01 -0500
Message-ID: <CAFwScO-8T=nTeDR=Waxnfc34rS38Ef=0dqO-39Jm6hSeUn0kHw@mail.gmail.com>
References: <AANLkTimF8y+yBwcs3S0UQxDV=xWyTQRKxzKxR7ZHZnFL@mail.gmail.com>
 <201101091919.44129.diegocg@gmail.com> <20110823172925.491070ef@atmarama.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Gour-Gadadhara Dasa <gour@atmarama.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110823172925.491070ef@atmarama.net>
List-ID: <linux-btrfs.vger.kernel.org>

it seems to me that the swap file interface doesn't make sense; to
"eliminate the middleman" and provide a direct swap tree type would be
the way to go, so a btrfs can hold swapped pages. Doing this would
AIUI require:
1) direct interface to btrfs trees, not via file-system interface
2) modifying swapping to use (1) instead of essentially the
swap-to-a-partition mechanisms to the "swap file" presented as a loop
device

I also wonder if you explicitly create a loop device for your swap
file and mount that as swap, will that work and if so how poorly.
