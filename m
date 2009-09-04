From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: Re: [PATCH] Don't exist from cleaner_kthread and transaction_kthread
	until kthread_should_stop is true
Date: Fri, 4 Sep 2009 09:06:52 +0900
Message-ID: <2014bcab0909031706y5d3397f9nd14fc1000c8b8aaf@mail.gmail.com>
References: <2014bcab0909030312i73f6cccfib1e612da0501cfc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2014bcab0909030312i73f6cccfib1e612da0501cfc6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

However, Vitaily Gusev notice me that kthread_stop() has been changed
recently so that it may executed for threads which was existed.
(commit  63706172f332fd3f6e7458ebfb35fa6de9c21dc5
              kthreads: rework kthread_stop())
