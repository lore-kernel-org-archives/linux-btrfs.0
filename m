Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:3508 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752291AbeBBUB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 15:01:57 -0500
Date: Sat, 3 Feb 2018 04:01:20 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:current-work 3/3] block/blk-wbt.h:96:1: sparse: two or
 more data types in declaration specifiers
Message-ID: <201802030415.H3vwxzEd%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git current-work
head:   1ac686f6d1b04b480cd245fb927180e1238bd3ac
commit: 1ac686f6d1b04b480cd245fb927180e1238bd3ac [3/3] current-work
reproduce:
        # apt-get install sparse
        git checkout 1ac686f6d1b04b480cd245fb927180e1238bd3ac
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> block/blk-wbt.h:96:1: sparse: two or more data types in declaration specifiers
>> block/blk-wbt.h:96:1: sparse: Trying to use reserved word 'struct' as identifier
   block/blk-wbt.h:96:8: sparse: Expected ; at end of declaration
   block/blk-wbt.h:96:8: sparse: got rq_qos
   block/blk-wbt.h:100:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.h:100:1: sparse: got }
   In file included from block/elevator.c:44:0:
   block/blk-wbt.h:89:36: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    enum wbt_flags rq_qos struct bio
    ^~~~~~
   block/blk-wbt.h:91:23: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:92:25: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:93:26: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:96:1: error: expected ';', identifier or '(' before 'struct'
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h:123:8: error: redefinition of 'struct rq_qos'
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h:96:8: note: originally defined here
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h: In function 'rq_qos_add':
   block/blk-wbt.h:169:16: error: 'struct request_queue' has no member named 'rqos'
    rqos->next = q->rqos;
    ^~
   block/blk-wbt.h:170:3: error: 'struct request_queue' has no member named 'rqos'
    q->rqos = rqos;
    ^~
--
>> block/blk-wbt.h:96:1: sparse: two or more data types in declaration specifiers
>> block/blk-wbt.h:96:1: sparse: Trying to use reserved word 'struct' as identifier
   block/blk-wbt.h:96:8: sparse: Expected ; at end of declaration
   block/blk-wbt.h:96:8: sparse: got rq_qos
   block/blk-wbt.h:100:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.h:100:1: sparse: got }
   block/blk-sysfs.c:432:56: sparse: no member 'min_lat_nsec' in struct rq_wb
   block/blk-sysfs.c:457:20: sparse: no member 'min_lat_nsec' in struct rq_wb
   block/blk-sysfs.c:459:20: sparse: no member 'min_lat_nsec' in struct rq_wb
   In file included from block/blk-sysfs.c:18:0:
   block/blk-wbt.h:89:36: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    enum wbt_flags rq_qos struct bio
    ^~~~~~
   block/blk-wbt.h:91:23: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:92:25: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:93:26: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:96:1: error: expected ';', identifier or '(' before 'struct'
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h:123:8: error: redefinition of 'struct rq_qos'
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h:96:8: note: originally defined here
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h: In function 'rq_qos_add':
   block/blk-wbt.h:169:16: error: 'struct request_queue' has no member named 'rqos'
    rqos->next = q->rqos;
    ^~
   block/blk-wbt.h:170:3: error: 'struct request_queue' has no member named 'rqos'
    q->rqos = rqos;
    ^~
   block/blk-sysfs.c: In function 'queue_wb_lat_show':
   block/blk-sysfs.c:432:49: error: 'struct rq_wb' has no member named 'min_lat_nsec'
    return sprintf(page, "%llun", div_u64(q->rq_wb->min_lat_nsec, 1000));
    ^~
   block/blk-sysfs.c: In function 'queue_wb_lat_store':
   block/blk-sysfs.c:457:6: error: 'struct rq_wb' has no member named 'min_lat_nsec'
    rwb->min_lat_nsec = wbt_default_latency_nsec(q);
    ^~
   block/blk-sysfs.c:459:6: error: 'struct rq_wb' has no member named 'min_lat_nsec'
    rwb->min_lat_nsec = val COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt 1000ULL;
    ^~
   block/blk-sysfs.c: In function 'queue_wb_lat_show':
   block/blk-sysfs.c:433:1: warning: control reaches end of non-void function
    }
    ^
--
>> block/blk-wbt.h:96:1: sparse: two or more data types in declaration specifiers
>> block/blk-wbt.h:96:1: sparse: Trying to use reserved word 'struct' as identifier
   block/blk-wbt.h:96:8: sparse: Expected ; at end of declaration
   block/blk-wbt.h:96:8: sparse: got rq_qos
   block/blk-wbt.h:100:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.h:100:1: sparse: got }
   block/blk-wbt.c:995:9: sparse: Expected ; at end of statement
   block/blk-wbt.c:995:9: sparse: got while
   block/blk-wbt.c:1000:11: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1000:11: sparse: got ->
   block/blk-wbt.c:1002:9: sparse: Expected ) in function declarator
   block/blk-wbt.c:1002:9: sparse: got (
>> block/blk-wbt.c:1002:9: sparse: Trying to use reserved word 'for' as identifier
   block/blk-wbt.c:1002:9: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1002:9: sparse: got )
   block/blk-wbt.c:1004:24: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1004:24: sparse: got ->
   block/blk-wbt.c:1004:50: sparse: Expected ) in function declarator
   block/blk-wbt.c:1004:50: sparse: got &
>> block/blk-wbt.c:1004:50: sparse: Trying to use reserved word 'void' as identifier
   block/blk-wbt.c:1004:50: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1004:50: sparse: got >
   block/blk-wbt.c:1004:50: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1004:50: sparse: got }
   block/blk-wbt.c:1005:9: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1005:9: sparse: got }
   block/blk-wbt.c:1007:4: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1007:4: sparse: got :
>> block/blk-wbt.c:1009:9: sparse: Trying to use reserved word 'return' as identifier
   block/blk-wbt.c:1009:16: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1009:16: sparse: got ret
   block/blk-wbt.c:1010:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1010:1: sparse: got }
   block/blk-wbt.c:1018:13: sparse: Expected ) in function declarator
   block/blk-wbt.c:1018:13: sparse: got !
>> block/blk-wbt.c:1018:9: sparse: Trying to use reserved word 'if' as identifier
   block/blk-wbt.c:1020:22: sparse: Expected ) in function declarator
   block/blk-wbt.c:1020:22: sparse: got ,
   block/blk-wbt.c:1022:9: sparse: Trying to use reserved word 'return' as identifier
   block/blk-wbt.c:1022:16: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1022:16: sparse: got 0
   block/blk-wbt.c:1023:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1023:1: sparse: got }
   block/blk-wbt.c:1029:9: sparse: Trying to use reserved word 'return' as identifier
   block/blk-wbt.c:1029:16: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1029:16: sparse: got 0
   block/blk-wbt.c:1030:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1030:1: sparse: got }
   block/blk-wbt.c:1037:13: sparse: Expected ) in function declarator
   block/blk-wbt.c:1037:13: sparse: got !
   block/blk-wbt.c:1037:9: sparse: Trying to use reserved word 'if' as identifier
   block/blk-wbt.c:1039:9: sparse: Trying to use reserved word 'return' as identifier
   block/blk-wbt.c:1039:16: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1039:16: sparse: got &
   block/blk-wbt.c:1040:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1040:1: sparse: got }
   block/blk-wbt.c:1048:22: sparse: Expected ) in function declarator
   block/blk-wbt.c:1048:22: sparse: got &
   block/blk-wbt.c:1049:11: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1049:11: sparse: got ->
   block/blk-wbt.c:1050:11: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1050:11: sparse: got ->
   block/blk-wbt.c:1052:20: sparse: Expected ) in function declarator
   block/blk-wbt.c:1052:20: sparse: got ->
>> block/blk-wbt.c:1052:9: sparse: Trying to use reserved word 'while' as identifier
   block/blk-wbt.c:1056:9: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1056:9: sparse: got }
   block/blk-wbt.c:1058:11: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1058:11: sparse: got ->
   block/blk-wbt.c:1059:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1059:1: sparse: got }
   block/blk-wbt.c:1068:11: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1068:11: sparse: got ->
   block/blk-wbt.c:1069:11: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1069:11: sparse: got ->
   block/blk-wbt.c:1071:20: sparse: Expected ) in function declarator
   block/blk-wbt.c:1071:20: sparse: got ->
   block/blk-wbt.c:1071:9: sparse: Trying to use reserved word 'while' as identifier
   block/blk-wbt.c:1075:9: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1075:9: sparse: got }
   block/blk-wbt.c:1077:9: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1077:9: sparse: got )
   block/blk-wbt.c:1079:24: sparse: Expected ; at end of declaration
   block/blk-wbt.c:1079:24: sparse: got .
   block/blk-wbt.c:1087:1: sparse: Expected ; at the end of type declaration
   block/blk-wbt.c:1087:1: sparse: got }
   block/blk-wbt.c:920:14: sparse: undefined identifier 'rwb'
   block/blk-wbt.c:924:13: sparse: no member 'cb' in struct rq_qos
   block/blk-wbt.c:926:18: sparse: no member 'cb' in struct rq_qos
   block/blk-wbt.h:169:23: sparse: no member 'rqos' in struct request_queue
   block/blk-wbt.h:170:10: sparse: no member 'rqos' in struct request_queue
   block/blk-wbt.c:932:38: sparse: no member 'cb' in struct rq_qos
   block/blk-wbt.c:123:16: sparse: no member 'wc' in struct rq_wb
   block/blk-wbt.c:158:47: sparse: no member 'last_comp' in struct rq_wb
   block/blk-wbt.c:181:13: sparse: undefined identifier 'rwb'
   block/blk-wbt.c:182:21: sparse: undefined identifier 'rwb'
   block/blk-wbt.c:196:25: sparse: undefined identifier 'rwb'
   block/blk-wbt.c:197:21: sparse: undefined identifier 'rwb'
   block/blk-wbt.c:198:53: sparse: undefined identifier 'rwb'
>> block/blk-wbt.c:198:53: sparse: cannot dereference this type
   block/blk-wbt.c:198:53: sparse: undefined identifier 'rwb'
>> block/blk-wbt.c:198:53: sparse: too many errors
   In file included from block/blk-wbt.c:27:0:
   block/blk-wbt.h:89:36: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    enum wbt_flags rq_qos struct bio
    ^~~~~~
   block/blk-wbt.h:91:23: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:92:25: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:93:26: warning: 'struct rq_qos' declared inside parameter list will not be visible outside of this definition or declaration
    void rq_qos struct blk_issue_stat
    ^~~~~~
   block/blk-wbt.h:96:1: error: expected ';', identifier or '(' before 'struct'
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h:123:8: error: redefinition of 'struct rq_qos'
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h:96:8: note: originally defined here
    struct rq_qos {
    ^~~~~~
   block/blk-wbt.h: In function 'rq_qos_add':
   block/blk-wbt.h:169:16: error: 'struct request_queue' has no member named 'rqos'
    rqos->next = q->rqos;
    ^~
   block/blk-wbt.h:170:3: error: 'struct request_queue' has no member named 'rqos'
    q->rqos = rqos;
    ^~
   block/blk-wbt.c: In function '__wbt_done':
   block/blk-wbt.c:123:9: error: 'struct rq_wb' has no member named 'wc'
    if (rwb->wc && !wb_recent_wait(rwb))
    ^~
   block/blk-wbt.c: In function 'wbt_done':
   block/blk-wbt.c:158:26: error: 'struct rq_wb' has no member named 'last_comp'
    wb_timestamp(rwb, &rwb->last_comp);
    ^~
   block/blk-wbt.c: In function 'calc_max_depth':
   block/blk-wbt.c:181:6: error: 'rwb' undeclared (first use in this function); did you mean
    if (rwb->queue_depth == 1) {
    ^~~
    rmb
   block/blk-wbt.c:181:6: note: each undeclared identifier is reported only once for each function it appears in
   block/blk-wbt.c: In function 'rwb_trace_step':
   block/blk-wbt.c:308:32: error: 'struct rq_wb' has no member named 'scale_step'; did you mean
    trace_wbt_step(bdi, msg, rwb->scale_step, rwb->cur_win_nsec,
    ^~~~~~~~~~
    enable_state
   block/blk-wbt.c:308:47: error: 'struct rq_wb' has no member named 'cur_win_nsec'
    trace_wbt_step(bdi, msg, rwb->scale_step, rwb->cur_win_nsec,
    ^~
   block/blk-wbt.c:309:45: error: 'struct rq_wb' has no member named 'wb_max'; did you mean
    rwb->wb_background, rwb->wb_normal, rwb->wb_max);
    ^~~~~~
    wb_normal
   block/blk-wbt.c: In function 'scale_up':
   block/blk-wbt.c:323:20: error: implicit declaration of function 'calc_wb_limits'; did you mean
    rqd->scaled_max = calc_wb_limits(rwb);
    ^~~~~~~~~~~~~~
    task_rlimit
   block/blk-wbt.c:323:35: error: 'rwb' undeclared (first use in this function); did you mean
    rqd->scaled_max = calc_wb_limits(rwb);
    ^~~
    rmb
   block/blk-wbt.c: In function 'scale_down':
   block/blk-wbt.c:352:2: error: implicit declaration of function 'rqd_trace_step'; did you mean
    rqd_trace_step(rqd, "step down");
    ^~~~~~~~~~~~~~
    rwb_trace_step
   block/blk-wbt.c: In function 'rwb_arm_timer':
   block/blk-wbt.c:357:11: error: 'struct rq_wb' has no member named 'scale_step'; did you mean
    if (rwb->scale_step > 0) {
    ^~~~~~~~~~
    enable_state
   block/blk-wbt.c:364:6: error: 'struct rq_wb' has no member named 'cur_win_nsec'
    rwb->cur_win_nsec = div_u64(rwb->win_nsec << 4,
    ^~
   block/blk-wbt.c:364:34: error: 'struct rq_wb' has no member named 'win_nsec'
    rwb->cur_win_nsec = div_u64(rwb->win_nsec << 4,
    ^~
   block/blk-wbt.c:365:21: error: 'struct rq_wb' has no member named 'scale_step'; did you mean
    int_sqrt((rwb->scale_step + 1) << 8));
    ^~~~~~~~~~
    enable_state
   block/blk-wbt.c:371:6: error: 'struct rq_wb' has no member named 'cur_win_nsec'
    rwb->cur_win_nsec = rwb->win_nsec;
    ^~
   block/blk-wbt.c:371:26: error: 'struct rq_wb' has no member named 'win_nsec'
    rwb->cur_win_nsec = rwb->win_nsec;
    ^~
   block/blk-wbt.c:374:29: error: 'struct rq_wb' has no member named 'cb'
    blk_stat_activate_nsecs(rwb->cb, rwb->cur_win_nsec);
    ^~
   block/blk-wbt.c:374:38: error: 'struct rq_wb' has no member named 'cur_win_nsec'
    blk_stat_activate_nsecs(rwb->cb, rwb->cur_win_nsec);
    ^~
   block/blk-wbt.c: In function 'wb_timer_fn':
   block/blk-wbt.c:386:61: error: 'struct rq_wb' has no member named 'scale_step'; did you mean
    trace_wbt_timer(rwb->queue->backing_dev_info, status, rwb->scale_step,
    ^~~~~~~~~~

vim +96 block/blk-wbt.h

    95	
  > 96	struct rq_qos {
    97		struct blk_stat_callback *cb;
    98		struct rq_qos_ops *ops;
    99		struct rq_qos *next;
   100	};
   101	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
