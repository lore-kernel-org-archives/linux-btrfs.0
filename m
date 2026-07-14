Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047591C6FF5
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784003940; cv=none; b=EpyocFRv12fCariazn8jiBj6d3rVVpZkrvGTmV3YNtLimE/NhMXsZbnuRnkn6hoY3TuRQjIWf8c47ejz0uxldPzlm/1kxqJmAomuj+w1Lyt5j+5gMPpIULf7vl9nHJBp9D0haauwAxQdoW8qJf/PhwzEy+gI1gunYsVDJsea0aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784003940; c=relaxed/simple;
	bh=63iCjLzjUGgIPWgpXrZGHZFDsLVx5r5fTToGdyRWLC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7Xe7r3DelfmsuPbWtUQV0uZ4+6s/ieTQWrJArYFoaoKNnJFPVGYEWq5XRYcpGzaVEmj2WAksKz3UUT1aNTBn0+gqANrv4au+fdu1oafI/2NZGwVMGIyapnq6KhdHVa1GG0i//G7ufNDjAm/Tv3uMPOrqWzNaEgBLRiNOYBk24c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=IaTzZsK7; arc=none smtp.client-ip=202.108.3.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="IaTzZsK7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1784003937;
	bh=E+DqH9w0CFDT+FpgETLE+ky0m/kkR8WsjPHPbAseKBI=;
	h=From:Subject:Date:Message-ID;
	b=IaTzZsK7OLSdN8/jQwtyffRKZ+RlJ8NEYrER/R4OT3QjJFWBCGgAdt7uN1tWIIfpt
	 9Hs8EODmZ78q/EWuz3l93EyUyvIRehQ6d3h+0UAUz/2w/dQj5oC3X02XypniOZjYuq
	 ffbkqnYHOVwEEbImelUYNI9sFJ9cGDOMJyD8wKV8=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.33) with ESMTP
	id 6A55BD5400007C9F; Tue, 14 Jul 2026 12:38:47 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 3282726685363
X-SMAIL-UIID: 5C427D2DEC9C42C9A88BBEA97C916B4E-20260714-123847-1
From: Hillf Danton <hdanton@sina.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Tue, 14 Jul 2026 12:38:33 +0800
Message-ID: <20260714043834.554-1-hdanton@sina.com>
In-Reply-To: <33277fd6-0479-4f6c-bc21-f25f7179d2dc@I-love.SAKURA.ne.jp>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Jul 2026 20:02:52 +0900 Tetsuo Handa wrote:
>On 2026/07/13 12:04, Hillf Danton wrote:
>> On Tue, 9 Jun 2026 18:50:13 +0100 Al Viro wrote:
>>> On Sun, Jun 07, 2026 at 07:54:58PM +0900, Tetsuo Handa wrote:
>>>> syzbot is reporting NULL pointer dereference in lo_rw_aio() [1][2].
>>>> An analysis by the Gemini AI collaborator [3] considers that this problem
>>>> is caused by a timing shift primarily exposed by commit 65565ca5f99b
>>>> ("block: unify the synchronous bi_end_io callbacks"), along with helper
>>>> refactorings like commit 92c3737a2473 ("block: add a bio_submit_or_kill
>>>> helper").
>>>>
>>>> But due to difficulty of reproducing this race, discussion about what is
>>>> happening and how to fix this problem is stalling. Also, we haven't
>>>> identified how many filesystems are subjected to this problem.
>>>>
>>>> Therefore, this patch introduces a grace period for flushing pending I/O
>>>> requests (which should be a good thing from the perspective of defensive
>>>> programming) so that we won't hit NULL pointer dereference problem, and
>>>> also emits BUG: message in order to help filesystem developers identify
>>>> the caller of an I/O request that failed to wait for completion so that
>>>> filesystem developers can fix such caller to wait for completion.
>>>>
>>>> Note that emitting BUG: message is enabled only if CONFIG_KCOV=y, for
>>>> this check is a waste of computation resources for almost all users.
>>>
>>> Still breaks xfs/259, same as the version in next-20260605...
>>>
>> And syzbot report [1]
>> 
>> [1] https://lore.kernel.org/lkml/6a54399f.278cdcd2.e885.0023.GAE@google.com/
>
> No. This report is from upstream tree where "loop: Fix NULL pointer dereference
> in lo_rw_aio()" is not yet applied.
>
The issue remains but this work stalls.
